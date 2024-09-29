output "web_app_windows_urls" {
  value       = var.windows_webapp_count > 0 ? [for i in range(var.windows_webapp_count) : "https://${azurerm_windows_web_app.webapp_windows[i].default_hostname}"] : null
  description = "URLs of the windows web Apps"
}









