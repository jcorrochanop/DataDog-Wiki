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

variable "alert_emails" {
  description = "Lista de correos electrónicos para alertas"
  type        = list(string)
}
