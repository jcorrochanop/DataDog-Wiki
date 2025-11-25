variable "gcp_credentials" {
  type        = string
  description = "Ruta al archivo JSON de credenciales de la cuenta de servicio en Google Cloud"
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

variable "gcp_zone" {
  type        = string
  description = "Zona de la VM en Google Cloud"
  default     = "us-south1-b"
}