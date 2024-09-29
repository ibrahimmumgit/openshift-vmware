# Resource to write the web app names to a file
resource "local_file" "linux_web_app_names_file" {
  count    = var.linux_webapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_linux_webapp_names)
  filename = "${path.module}/linux_web_app_names.txt"
  depends_on = [
    azurerm_linux_web_app.webapp_linux
  ]
}
