variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application Key"
  sensitive   = true
}

variable "datadog_api_url" {
  type        = string
  description = "Datadog API URL"
  default     = "https://api.datadoghq.eu/"
}

variable "gcp_credentials" {
  type        = string
  description = "Ruta al archivo JSON de credenciales de la cuenta de servicio en Google Cloud"
  default     = "../../credentials/balmy-mile-452912-p6-0696cfbdbf94.json"
}

variable "gcp_project" {
  type        = string
  description = "ID del proyecto en Google Cloud"
  default     = "balmy-mile-452912-p6"
}

variable "gcp_region" {
  type        = string
  description = "Región principal de despliegue en Google Cloud"
  default     = "us-central1"
}

variable "function_zip_path" {
  type        = string
  description = "Ruta local al archivo ZIP con el código de la Cloud Function"
  default     = "function_code/function.zip"
}