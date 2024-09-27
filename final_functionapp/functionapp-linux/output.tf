output "function_app_linux_urls" {
  value       = var.linux_funcapp_count > 0 ? [for i in range(var.linux_funcapp_count) : "https://${azurerm_linux_function_app.funcapp_linux[i].default_hostname}"] : null
  description = "URLs of the Linux Function Apps"
}









