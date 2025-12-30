module "datadog_log_export" {
  source  = "terraform-google-modules/log-export/google//examples/datadog-sink"
  version = "~> 8.0"

  project_id = local.project_id

  # Filtro de logs que quieres mandar (aquí todo Cloud Run)
  log_sink_filter = "resource.type=cloud_run_revision"

  # Nombre del topic/subscription de Pub/Sub
  topic_name        = local.logs_destination_topic
  subscription_name = "${local.logs_destination_topic}-sub"

  # Parámetros del Dataflow job Pub/Sub -> Datadog
  dataflow_job_name        = local.dataflow_job_name
  dataflow_temp_bucket_name = local.temp_gcs_bucket_name

  # Config específica Datadog 
  datadog_region  = "eu"                        
  datadog_api_key = var.datadog_api_key        
}