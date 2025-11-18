terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.21.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name
  machine_type = var.vm_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }

}


locals {
  vm_host_actual = "${var.vm_name}.${var.gcp_zone}.c.${var.gcp_project}.internal"
}

resource "null_resource" "install_datadog_agent" {
  provisioner "remote-exec" {
    inline = [
      "DD_API_KEY=${var.datadog_api_key} DD_SITE=datadoghq.eu bash -c \"$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)\""
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
    }
  }

  depends_on = [
    google_compute_instance.vm_instance
  ]
}


resource "datadog_dashboard" "dashboard_vm" {
  title       = "Dashboard de la VM"
  description = "Monitorización personalizada de la instancia"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Usage (host)"
      request {
        q = "avg:system.cpu.user{host:${local.vm_host_actual}} by {host}"
        display_type = "line"
        style { palette = "dog_classic" }
      }
      legend_size = "auto"
    }
  }

  widget {
    query_value_definition {
      title = "Memoria usada (%)"
      autoscale = true
      request {
        q = "avg:system.mem.pct_usable{host:${local.vm_host_actual}}"
        aggregator = "avg"
      }
    }
  }

  widget {
    query_value_definition {
      title = "Disk Used (MiB)"
      autoscale = true
      request {
        q = "avg:system.disk.used{host:${local.vm_host_actual}}"
        aggregator = "avg"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Load average"
      request {
        q = "avg:system.load.1{host:${local.vm_host_actual}}"
        display_type = "line"
        style { palette = "dog_classic" }
      }
      legend_size = "auto"
    }
  }

  widget {
    timeseries_definition {
      title = "Bytes sent"
      request {
        q = "avg:system.net.bytes_sent{host:${local.vm_host_actual}}"
        display_type = "line"
        style { palette = "dog_classic" }
      }
      legend_size = "auto"
    }
  }
}

