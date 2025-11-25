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

locals {
  email_notifications = join(" ", [for email in var.alert_emails : "@${email}"])
}

resource "datadog_monitor" "cpu_alert" {
  name    = "Alerta: Alto uso de CPU en contenedor"
  type    = "metric alert"
  message = local.email_notifications
  query = "avg(last_5m):avg:docker.cpu.usage{env:dev} by {container_name} > 80"

  monitor_thresholds {
    warning  = 60
    critical = 80
  }

}