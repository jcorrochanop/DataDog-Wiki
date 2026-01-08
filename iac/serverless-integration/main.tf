terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "remove-it-482111"
  region  = "us-central1"
}

provider "google-beta" {
  project = "remove-it-482111"
  region  = "us-central1"
}

module "datadog-integration" {
  source                    = "./gcp-datadog-module"
  project_id                = "remove-it-482111"
  dataflow_job_name         = "datadog-logs-forwarder"
  dataflow_temp_bucket_name = "remove-it-datadog-temp"
  topic_name                = "datadog-export-topic"
  subscription_name         = "datadog-export-sub"
  vpc_name                  = "default"
  subnet_name               = "default"
  subnet_region             = "us-central1"
  datadog_api_key           = "3b34ac461e4bfea75f61d1484dd6f90d"
  datadog_site_url          = "https://http-intake.logs.datadoghq.eu"
  log_sink_in_folder        = false
  folder_id                 = ""
  inclusion_filter          = "resource.type=cloud_run_revision OR resource.type=gae_app"
}
