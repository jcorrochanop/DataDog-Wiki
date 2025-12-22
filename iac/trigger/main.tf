terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.21.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

# Webhook que dispara GitHub Actions
resource "datadog_webhook" "trigger_github_actions" {
  name = "trigger-github-restart-pod"
  
  # URL actualizada con tu repositorio
  url = "https://api.github.com/repos/jcorrochanop/DataDog-Wiki/dispatches"
  
  # encode_as debe ser "json" o "form" (no encode_as_form)
  encode_as = "json"
  
  custom_headers = jsonencode({
    "Authorization" = "token ${var.github_token}",
    "Accept"        = "application/vnd.github.v3+json"
  })
  
  # Payload con datos específicos del pod
  payload = jsonencode({
    "event_type" = "restart-pod",
    "client_payload" = {
      "alert_title"   = "$TITLE",
      "alert_status"  = "$ALERT_STATUS",
      "cluster"       = "{{cluster_name}}",
      "pod_name"      = "{{pod_name}}",
      "namespace"     = "{{kube_namespace}}",
      "deployment"    = "{{kube_deployment}}",
      "alert_id"      = "$ID"
    }
  })
}

# Monitor de CPU por pod
resource "datadog_monitor" "k8s_pod_high_cpu" {
  name = "K8s - CPU alta en pod (reinicio automático)"
  type = "metric alert"
  
  query = "avg(last_5m):avg:kubernetes.cpu.usage.total{cluster_name:my-datadog-cluster} by {pod_name,kube_namespace,cluster_name,kube_deployment} > 800000000"
  
  message = <<EOM
🚨 CPU alta en el pod {{pod_name}} (namespace {{kube_namespace}}) del cluster {{cluster_name}}.

Deployment afectado: {{kube_deployment}}

Se dispara reinicio automático vía GitHub Actions.

@webhook-${datadog_webhook.trigger_github_actions.name}
EOM
  
  monitor_thresholds {
    critical = 800000000
    warning  = 650000000
  }
  
  notify_no_data    = false
  renotify_interval = 0
  
  tags = [
    "env:sandbox",
    "type:autofix",
    "automation:github-actions",
  ]
}

# Monitor de memoria por pod
resource "datadog_monitor" "k8s_pod_high_memory" {
  name = "K8s - Memoria alta en pod (reinicio automático)"
  type = "metric alert"
  
  query = "avg(last_5m):avg:kubernetes.memory.usage{cluster_name:my-datadog-cluster} by {pod_name,kube_namespace,kube_deployment} > 1073741824"
  
  message = <<EOM
🚨 Memoria alta en el pod {{pod_name}} (namespace {{kube_namespace}}).

@webhook-${datadog_webhook.trigger_github_actions.name}
EOM
  
  monitor_thresholds {
    critical = 1073741824
    warning  = 858993459
  }
  
  notify_no_data    = false
  renotify_interval = 0
  
  tags = [
    "env:sandbox",
    "type:autofix",
  ]
}

