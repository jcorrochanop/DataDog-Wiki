variable "gcp_credentials" {
  type        = string
  description = "Ruta al archivo JSON de credenciales de la cuenta de servicio en Google Cloud"
}

variable "gcp_project" {
  type        = string
  description = "ID del proyecto en Google Cloud"
  default     = "flash-yen-478511-p6"
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

variable "vm_name" {
  type        = string
  description = "Nombre de la instancia de VM a crear"
  default     = "vm-instance-datadog"
}

variable "vm_type" {
  type        = string
  description = "Tipo de máquina (machine_type) para la VM de Google Cloud"
  default     = "e2-medium"
}

variable "vm_image" {
  type        = string
  description = "Imagen base del sistema operativo para la VM"
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20251111"
}

variable "ssh_user" {
  type        = string
  description = "Usuario SSH utilizado para conectarse a la VM"
  default     = "ubuntu"
}

variable "ssh_private_key" {
  type        = string
  description = "Ruta al archivo de la clave privada SSH para el acceso remoto"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  type        = string
  description = "Ruta al archivo de la clave pública SSH para el acceso remoto"
  default     = "~/.ssh/id_rsa.pub"
}

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

