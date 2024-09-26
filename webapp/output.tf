output "web_app_linux" {
  value       = var.linux_webapp_count > 0 ? [for i in range(var.linux_webapp_count) : "${azurerm_linux_web_app.webapp_linux[i].default_hostname}"] : null
  description = "URLs of the Linux webtion Apps"
}

output "web_app_windows" {
  value       = var.windows_webapp_count > 0 ? [for i in range(var.windows_webapp_count) : "${azurerm_windows_web_app.webapp_windows[i].default_hostname}"] : null
  description = "URLs of the Windows webtion Apps"
}

output "linux_content" {
  value       = local_file.linux_web_app_names_file[0].content

}



