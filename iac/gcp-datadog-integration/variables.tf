variable "datadog_api_key" {
  description = "The API key for Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "The application key for Datadog"
  type        = string
  sensitive   = true
}

variable "gcp_project" {
  type        = string
  description = "ID del proyecto en Google Cloud"
  default     = "balmy-mile-452912-p6"
}

variable "gcp_region" {
  type        = string
  description = "Región principal de despliegue en Google Cloud"
  default     = "us-south1"
}

