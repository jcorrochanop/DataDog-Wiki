terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

resource "datadog_dashboard" "docker_monitoring_tf" {
  title       = "Docker Monitoring (Terraform)"
  description = "Dashboard de monitoreo Docker creado con Terraform"
  layout_type = "ordered"
  
  # Variables de template para filtrar
  template_variable {
    name    = "container_name"
    prefix  = "container_name"
    defaults = ["*"]
  }

  template_variable {
    name    = "env"
    prefix  = "env"
    defaults = ["*"]
  }
  
  template_variable {
    name    = "service"
    prefix  = "service"
    defaults = ["*"]
  }

  # Widget de texto: Título/Descripción del Dashboard
  widget {
    note_definition {
      content          = "Dashboard de Monitorización Docker"
      background_color = "white"
      font_size        = "56"
      text_align       = "center"
      vertical_align   = "center"
      show_tick        = false
      has_padding      = true
    }

    widget_layout {
      width  = 8   # Número de columnas
      height = 2   # Número de filas
      x      = 0   # Posición horizontal (empezando desde 0)
      y      = 0   # Posición vertical (empezando desde 0)
    }
  }

  # Widget 1: Número de contenedores activos
  widget {
    query_value_definition {
      title     = "Contenedores Activos"
      autoscale = true
      precision = 0
      live_span = "1h"
      
      request {
        q          = "sum:docker.containers.running{$env}"
        aggregator = "avg"
      }
    }

    widget_layout {
      width  = 4   # Número de columnas
      height = 2   # Número de filas
      x      = 8   # Posición horizontal (empezando desde 0)
      y      = 0   # Posición vertical (empezando desde 0)
    }
  }

  # Widget 2: Mapa de calor - Uso de Memoria
  widget {
    heatmap_definition {
      title     = "Mapa de Calor - Uso de Memoria Cache"
      live_span = "1h"
      request {
        q = "avg:docker.mem.cache{$env, $service} by {container_name}"
        style {
          palette = "dog_classic"
        }
      }
      yaxis {
        include_zero = true
      }
    }

    widget_layout {
      width  = 12   # Número de columnas
      height = 4   # Número de filas
      x      = 0   # Posición horizontal (empezando desde 0)
      y      = 2   # Posición vertical (empezando desde 0)
    }
  }


  # Widget 3: I/O de Docker (lecturas y escrituras)
  widget {
    timeseries_definition {
      title       = "I/O de Docker (Lectura/Escritura)"
      show_legend = true
      live_span   = "1h"
      
      request {
        display_type = "line"
        q            = "avg:docker.io.write_bytes{$container_name, $env, $service} by {container_name}"
        
        style {
          palette    = "dog_classic"
          line_type  = "solid"
          line_width = "normal"
        }
      }
      
      request {
        display_type = "line"
        q            = "avg:docker.io.read_bytes{$container_name, $env, $service} by {container_name}"
        
        style {
          palette    = "cool"
          line_type  = "solid"
          line_width = "normal"
        }
      }
      
      yaxis {
        include_zero = true
        scale        = "linear"
      }
    }

    widget_layout {
      width  = 6   # Número de columnas
      height = 3   # Número de filas
      x      = 0   # Posición horizontal (empezando desde 0)
      y      = 6   # Posición vertical (empezando desde 0)
    }
  }

  # Widget 4: Uso de CPU por contenedor
  widget {
    timeseries_definition {
      title       = "Uso de CPU por Contenedor"
      show_legend = true
      live_span   = "1h"
      
      request {
        display_type = "line"
        q            = "avg:docker.cpu.usage{$container_name, $env, $service} by {container_name}"
        
        style {
          palette    = "dog_classic"
          line_type  = "solid"
          line_width = "normal"
        }
      }
      
      yaxis {
        include_zero = true
      }
    }

    widget_layout {
      width  = 6   # Número de columnas
      height = 3   # Número de filas
      x      = 6   # Posición horizontal (empezando desde 0)
      y      = 6   # Posición vertical (empezando desde 0)
    }
  }

  # Widget 5: Top 5 contenedores por uso de CPU
  widget {
    toplist_definition {
      title     = "Top 5 - Uso de CPU"
      live_span = "1h"
      
      request {
        q = "top(avg:docker.cpu.usage{$env, $container_name, $service} by {container_name}, 5, 'mean', 'desc')"
        
        style {
          palette = "dog_classic"
        }
      }
    }

    widget_layout {
      width  = 6   # Número de columnas
      height = 3   # Número de filas
      x      = 0   # Posición horizontal (empezando desde 0)
      y      = 9   # Posición vertical (empezando desde 0)
    }
  }

  # Widget 6: Uso de memoria (RSS y Cache)
  widget {
    timeseries_definition {
      title       = "Uso de Memoria (RSS y Cache)"
      show_legend = true
      live_span   = "1h"
      
      request {
        display_type = "line"
        q            = "avg:docker.mem.cache{$env, $service} by {container_name}"
        
        style {
          palette    = "dog_classic"
          line_type  = "solid"
          line_width = "normal"
        }
      }
      
      request {
        display_type = "line"
        q            = "avg:docker.mem.rss{$env, $service} by {container_name}"
        
        style {
          palette    = "warm"
          line_type  = "solid"
          line_width = "normal"
        }
      }
      
      yaxis {
        include_zero = true
      }
    }

    widget_layout {
      width  = 6   # Número de columnas
      height = 3   # Número de filas
      x      = 6   # Posición horizontal (empezando desde 0)
      y      = 9   # Posición vertical (empezando desde 0)
    }

  }

  # Widget 7: Logs de contenedores Docker
  widget {
    log_stream_definition {
      title     = "Logs de Contenedores Docker"
      indexes   = []
      query     = "container_name:my-nginx OR container_name:my-redis OR container_name:my-postgres OR source:nginx OR source:redis OR source:postgres"
      columns   = ["timestamp", "container_name", "service", "source", "content"]
      live_span = "1h"
    }

    widget_layout {
      width  = 12   # Número de columnas
      height = 4   # Número de filas
      x      = 0   # Posición horizontal (empezando desde 0)
      y      = 12   # Posición vertical (empezando desde 0)
    }
  }

  # Widget 8: Event Stream - Eventos Docker
  widget {
    list_stream_definition {
      title = "Eventos Docker (start, stop, restart)"

      request {
        response_format = "event_list"
        query {
          data_source   = "event_stream"
          event_size    = "s"
          query_string  = ""   
        }
        columns {
          field = "timestamp"
          width = "auto"
        }
        columns {
          field = "source"
          width = "auto"
        }
        columns {
          field = "content"
          width = "full"
        }
      }
    }

    widget_layout {
      width  = 12   # Número de columnas
      height = 3   # Número de filas
      x      = 0   # Posición horizontal (empezando desde 0)
      y      = 16   # Posición vertical (empezando desde 0)
    }

  }

}
