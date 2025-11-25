terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
}

# Crear el cluster GKE
resource "google_container_cluster" "primary" {
  name     = "my-datadog-cluster"
  location = var.gcp_zone

  # Modo autopilot desactivado 
  initial_node_count       = 2
  remove_default_node_pool = false

  deletion_protection = false

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Configuración de red (usa la red default)
  network    = "default"
  subnetwork = "default"
}
