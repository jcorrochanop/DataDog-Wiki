locals {
  project_id              = "remove-it-482111"
  logs_destination_topic  = "logs-to-datadog"       
  logs_destination_region = "europe-west1"
  dataflow_job_name       = "logs-to-datadog-job"
  temp_gcs_bucket_name    = "remove-it-482111-datadog-tmp"  
}