# Resource to write the function app names to a file
resource "local_file" "windows_function_app_names_file" {
  count    = var.windows_funcapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_windows_funcapp_names)
  filename = "${path.module}/windows_function_app_names.txt"
  depends_on = [
    azurerm_windows_function_app.funcapp_windows
  ]
}
