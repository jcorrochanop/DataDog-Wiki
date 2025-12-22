variable "datadog_api_key" {
  type      = string
  sensitive = true
}

variable "datadog_app_key" {
  type      = string
  sensitive = true
}

variable "datadog_api_url" {
  type    = string
  default = "https://api.datadoghq.eu"
}

variable "github_token" {
  type    = string
  sensitive = true
}
