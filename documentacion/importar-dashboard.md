# Exportar y gestionar dashboards de Datadog con Terraform

En este proceso suelen usarse utilidades como `jq` para limpiar y organizar los archivos JSON exportados desde Datadog, justo antes de gestionarlos bajo una definición declarativa en Terraform.

---

## 1. Formatear el JSON exportado

Por lo general, al exportar un dashboard desde Datadog, el archivo JSON aparece en una sola línea y resulta difícil de revisar manualmente. Normalmente, lo que se hace es instalar `jq`, una herramienta de línea de comandos bastante usada, y con ella se formatea el archivo exportado para que quede bien indentado y legible.

```bash
sudo apt update
sudo apt install -y jq
jq '.' dashboard.json > dashboard_pretty.json
```

De esta manera el archivo `dashboard_pretty.json` queda mucho más cómodo para trabajar, tanto en equipo como para tareas de automatización.

***

## 2. Gestionar el dashboard como recurso en Terraform

Cuando se quiere controlar el dashboard con infraestructura como código, se suele crear un recurso de Terraform utilizando el JSON exportado. Es habitual tener una definición similar a lo siguiente:

```hcl
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

resource "datadog_dashboard_json" "cpu_dashboard" {
  dashboard = file("${path.module}/../../datadog_exports/dashboard_pretty.json")
}
```

Por lo general, la ruta se ajusta según la organización de carpetas del proyecto; muchas veces suele tenerse una carpeta especial para los JSON exportados.