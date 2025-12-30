provider "google" {
  project = "remove-it-482111"
  region  = "europe-west1"
}

resource "google_cloud_run_service" "terraform_with_sidecar" {
  name     = "flog-sidecar-test"
  location = "europe-west1"
  
  template {
    metadata {
      annotations = {
        "run.googleapis.com/container-dependencies" = jsonencode({
          "main-app" = ["datadog-sidecar"]
        })
      }
      labels = {
        service = "flog-sidecar-test"
      }
    }
    
    spec {
      volumes {
        name = "shared-volume"
        empty_dir {
          medium = "Memory"
        }
      }
      
      # Main application container
      containers {
        name  = "main-app"
        image = "gcr.io/remove-it-482111/datadog-python-sample:v1"
        
        ports {
          container_port = 8080
        }
        
        startup_probe {
          tcp_socket {
            port = 8080
          }
          initial_delay_seconds = 0
          period_seconds        = 10
          failure_threshold     = 3
          timeout_seconds       = 1
        }
        
        volume_mounts {
          name       = "shared-volume"
          mount_path = "/shared-volume"
        }
        
        env {
          name  = "DD_SERVICE"
          value = "flog-sidecar-test"
        }
        
        env {
          name  = "DD_ENV"
          value = "dev"
        }
        
        env {
          name  = "DD_VERSION"
          value = "1.0.0"
        }
        
        env {
          name  = "DD_SERVERLESS_LOG_PATH"
          value = "/shared-volume/logs/*.log"
        }
        
        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
      
      # Sidecar container
      containers {
        name  = "datadog-sidecar"
        image = "gcr.io/datadoghq/serverless-init:latest"
        
        startup_probe {
          tcp_socket {
            port = 12345
          }
          initial_delay_seconds = 0
          period_seconds        = 10
          failure_threshold     = 3
          timeout_seconds       = 1
        }
        
        volume_mounts {
          name       = "shared-volume"
          mount_path = "/shared-volume"
        }
        
        env {
          name  = "DD_SITE"
          value = "datadoghq.eu"
        }
        
        env {
          name  = "DD_API_KEY"
          value = "307f58cc92807ff9001f2e824ef757ee"
        }
        
        env {
          name  = "DD_SERVICE"
          value = "flog-sidecar-test"
        }
        
        env {
          name  = "DD_ENV"
          value = "dev"
        }
        
        env {
          name  = "DD_VERSION"
          value = "1.0.0"
        }
        
        env {
          name  = "DD_HEALTH_PORT"
          value = "12345"
        }
        
        env {
          name  = "DD_SERVERLESS_LOG_PATH"
          value = "/shared-volume/logs/*.log"
        }
        
        env {
          name  = "DD_APM_ENABLED"
          value = "true"
        }
        
        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.terraform_with_sidecar.name
  location = google_cloud_run_service.terraform_with_sidecar.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
