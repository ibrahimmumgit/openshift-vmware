# Resource to write the function app names to a file
resource "local_file" "linux_function_app_names_file" {
  count    = var.linux_funcapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_linux_funcapp_names)
  filename = "${path.module}/linux_function_app_names.txt"
  depends_on = [
    azurerm_linux_function_app.funcapp_linux
  ]
}
