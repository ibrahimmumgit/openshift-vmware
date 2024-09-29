output "web_app_linux_urls" {
  value       = var.linux_webapp_count > 0 ? [for i in range(var.linux_webapp_count) : "https://${azurerm_linux_web_app.webapp_linux[i].default_hostname}"] : null
  description = "URLs of the Linux web Apps"
}









