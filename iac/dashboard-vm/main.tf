terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.21.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

resource "datadog_dashboard" "dashboard_vm" {
  title       = "Dashboard de la VM"
  description = "Monitorización personalizada de la instancia"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Usage (host)"
      request {
        q = "avg:system.cpu.user{host:${var.vm_host}}"
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
        q = "avg:system.mem.pct_usable{host:${var.vm_host}}"
        aggregator = "avg"
      }
    }
  }

  widget {
    query_value_definition {
      title = "Disk Used (MiB)"
      autoscale = true
      request {
        q = "avg:system.disk.used{host:${var.vm_host}}"
        aggregator = "avg"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Load average"
      request {
        q = "avg:system.load.1{host:${var.vm_host}}"
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
        q = "avg:system.net.bytes_sent{host:${var.vm_host}}"
        display_type = "line"
        style { palette = "dog_classic" }
      }
      legend_size = "auto"
    }
  }
}

