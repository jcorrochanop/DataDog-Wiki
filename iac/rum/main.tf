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
  api_url = "https://api.datadoghq.eu/"
}

locals {
  # Leer el CSV
  csv_data = csvdecode(file("applications.csv"))
  
  # Crear el mapa de aplicaciones desde el CSV 
  rum_applications = {
    for row in local.csv_data : replace("${row["App ID"]}-${row["RUM - Name"]}", " ", "-") => {
      type = startswith(row["App ID"], "IOS") ? "ios" : "android"
    }
  }
  
  # Preparar contenido del CSV de exportación
  csv_header = "Application Name,Type,Application ID,Client Token\n"
  csv_rows = [
    for name, app in datadog_rum_application.apps :
    "${name},${app.type},${app.id},${app.client_token}"
  ]
  csv_export_content = "${local.csv_header}${join("\n", local.csv_rows)}"
}

resource "datadog_rum_application" "apps" {
  for_each = local.rum_applications
  
  name = each.key
  type = each.value.type
}

# Exportar automáticamente los tokens a CSV
resource "local_file" "rum_tokens_export" {
  filename = "${path.module}/rum_applications_tokens.csv"
  content  = local.csv_export_content
}
