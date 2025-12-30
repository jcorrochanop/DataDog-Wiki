variable "datadog_api_key" {
  type        = string
  description = "Datadog API key usada por el Dataflow para mandar logs"
  sensitive   = true
}
