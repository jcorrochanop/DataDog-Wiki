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

provider "google" {
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "datadog_monitor" "nginx_cpu_monitor" {
  name    = "CPU alto en mi-nginx"
  type    = "metric alert"
  query   = "avg(last_5m):avg:kubernetes.cpu.usage.total{kube_deployment:mi-nginx} > 300000"
  message = "El pod {{pod_name}} tiene CPU > 0.3 cores (300k microcores). @tu-email @webhook-nombrewebhook"

  monitor_thresholds {
    warning  = 250000
    critical = 300000
  }

  notify_no_data    = true
  no_data_timeframe = 15
  tags              = ["env:test", "monitor:nginx-cpu"]
}

resource "google_service_account" "function_sa" {
  account_id   = "function-datadog"
  display_name = "Datadog Webhook Function"
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.gcp_project}-function-code"
  location = var.gcp_region
}

resource "google_storage_bucket_object" "object" {
  name   = "function.zip"
  bucket = google_storage_bucket.bucket.name
  source = var.function_zip_path      
}

resource "google_cloudfunctions_function" "datadog_webhook" {
  name        = "datadog-webhook-handler"
  runtime     = "python39"
  entry_point = "main"
  region      = var.gcp_region

  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.object.name

  trigger_http          = true
  available_memory_mb   = 128
  service_account_email = google_service_account.function_sa.email
}

resource "datadog_webhook" "scale_deployment" {
  name    = "webhook-nombrewebhook"
  url     = google_cloudfunctions_function.datadog_webhook.https_trigger_url
  payload = "{\"alert\": \"{{state}}\", \"msg\": \"{{message}}\"}"
}





