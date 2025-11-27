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

resource "datadog_dashboard" "gcp_project_dashboard" {
  title       = "GCP Proyecto sandbox"
  description = "Estado de las VMs GCE y GKE del proyecto balmy-mile-452912-p6"
  layout_type = "ordered"

  # =====================
  # VMs GCE (integración GCP)
  # =====================

  # CPU por VM en el proyecto (métrica nativa GCE)
  widget {
    timeseries_definition {
      title = "CPU % por VM (proyecto sandbox)"
      request {
        q            = "avg:gcp.gce.instance.cpu.utilization{gcp_account:sandbox} by {name}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      legend_size = "auto"
    }
  }

  # Memoria (requiere Agent instalado en las VMs)
  widget {
    timeseries_definition {
      title = "Memoria usada % por VM (REQUIERE AGENT)"
      request {
        q            = "avg:system.mem.pct_usable{gcp_account:sandbox} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      legend_size = "auto"
    }
  }

  # Tráfico de red: bytes enviados por VM (métrica GCE)
  widget {
    timeseries_definition {
      title = "Bytes enviados por VM"
      request {
        q            = "sum:gcp.gce.instance.network.sent_bytes_count{gcp_account:sandbox} by {name}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      legend_size = "auto"
    }
  }

  # Tráfico de red: bytes recibidos por VM (métrica GCE)
  widget {
    timeseries_definition {
      title = "Bytes recibidos por VM"
      request {
        q            = "sum:gcp.gce.instance.network.received_bytes_count{gcp_account:sandbox} by {name}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      legend_size = "auto"
    }
  }

  # Uptime por VM
  widget {
    timeseries_definition {
      title = "Uptime de VMs (segundos)"
      request {
        q            = "avg:gcp.gce.instance.uptime{gcp_account:sandbox} by {name}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      legend_size = "auto"
    }
  }

  # Número de VMs activas en el proyecto/cuenta
  widget {
    query_value_definition {
      title     = "Número de VMs activas (sandbox)"
      autoscale = true
      request {
        q          = "count:gcp.gce.instance.uptime{gcp_account:sandbox}"
        aggregator = "last"
      }
    }
  }

  # =====================
  # Cluster GKE (SOLO INTEGRACIÓN GCP)
  # =====================

# CPU usada por nodo del cluster (vista de nodos GKE vía integración GCP)
  widget {
    timeseries_definition {
      title = "CPU % por nodo GKE (integración GCP)"
      request {
        q            = "avg:gcp.gke.node.cpu.allocatable_utilization{gcp_account:sandbox} by {node_name}"
        display_type = "line"
        style {
          palette = "cool"
        }
      }
      legend_size = "auto"
    }
  }

  # Número de nodos en el cluster (vista de plataforma)
  widget {
    query_value_definition {
      title     = "Nodos GKE en sandbox (integración GCP)"
      autoscale = true
      request {
        q          = "count:gcp.gke.node.cpu.allocatable_utilization{gcp_account:sandbox}"
        aggregator = "last"
      }
    }
  }

  # =====================
  # Ejemplo que NO verás solo con integración GCP
  # =====================

  # CPU por pod (REQUIERE AGENT EN EL CLÚSTER)
  widget {
    timeseries_definition {
      title = "CPU por pod (REQUIERE AGENT EN K8s)"
      request {
        # Métrica típica de K8s vía Agent; no existirá solo con integración GCP
        q            = "avg:kubernetes.cpu.usage.total{cluster_name:mi-cluster} by {pod_name}"
        display_type = "line"
        style {
          palette = "warm"
        }
      }
      legend_size = "auto"
    }
  }
}
