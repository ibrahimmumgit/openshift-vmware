# Resource to write the web app names to a file
resource "local_file" "windows_web_app_names_file" {
  count    = var.windows_webapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_windows_webapp_names)
  filename = "${path.module}/windows_web_app_names.txt"
  depends_on = [
    azurerm_windows_web_app.webapp_windows
  ]
}
