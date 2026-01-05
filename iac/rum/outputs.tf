output "rum_applications_tokens" {
  description = "Application IDs and Client Tokens for all RUM applications"
  value = {
    for name, app in datadog_rum_application.apps : name => {
      application_id = app.id
      client_token   = app.client_token
    }
  }
  sensitive = true
}

output "rum_applications_summary" {
  description = "Summary of created RUM applications"
  value = {
    for name, app in datadog_rum_application.apps : name => {
      type = app.type
      name = app.name
    }
  }
}