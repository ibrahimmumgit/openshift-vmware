output "function_app_windows_urls" {
  value       = var.windows_funcapp_count > 0 ? [for i in range(var.windows_funcapp_count) : "https://${azurerm_windows_function_app.funcapp_windows[i].default_hostname}"] : null
  description = "URLs of the windows Function Apps"
}









