output "function_app_linux_urls" {
  value       = var.linux_funcapp_count > 0 ? [for i in range(var.linux_funcapp_count) : "https://${azurerm_linux_function_app.funcapp_linux[i].default_hostname}"] : null
  description = "URLs of the Linux Function Apps"
}

output "linux_function_app_names_from_file" {
  value = local.linux_function_app_names_from_file
}

output "linux_function_app_names_count_from_file" {
  value = local.linux_function_app_names_count_from_file
}

output "nlinux_funcapp_names" {
  value = local.nlinux_funcapp_names
}

output "linux_funcapp_names" {
  value = local.linux_funcapp_names
}

output "truncated_linux_funcapp_names" {
  value = local.truncated_linux_funcapp_names
}

output "existing_funcapps_max_resource_numbers" {
  value = local.existing_funcapps_max_resource_numbers
}





