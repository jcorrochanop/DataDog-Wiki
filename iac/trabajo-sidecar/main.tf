terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}


provider "google" {
  project = "remove-it-482111"
  region  = "europe-west1"
}

############################
# Dataflow: Pub/Sub -> Datadog Logs
############################

resource "google_dataflow_flex_template_job" "logs_to_datadog" {
  name   = "logs-to-datadog-job"
  project = "remove-it-482111"
  region = "us-central1"

  container_spec_gcs_path = "gs://dataflow-templates/latest/flex/PubSub_to_Datadog"

  parameters = {
    inputSubscription     = "projects/remove-it-482111/subscriptions/logs-to-datadog-sub"
    datadogLogsApiUrl     = "https://http-intake.logs.datadoghq.eu/api/v2/logs"
    outputDeadletterTopic = "projects/remove-it-482111/topics/logs-to-datadog"
    apiKeySource          = "PLAINTEXT"
    apiKey                = "307f58cc92807ff9001f2e824ef757ee"
  }

  temp_gcs_location = "gs://remove-it-dataflow-temp"

  on_delete = "cancel"
}

