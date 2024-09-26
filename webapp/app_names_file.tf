# Resource to write the web app names to a file
resource "local_file" "linux_web_app_names_file" {
  count    = var.linux_webapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_linux_webapp_names)
  filename = "${path.module}/linux_web_app_names.txt"
  depends_on = [
    azurerm_linux_web_app.webapp_linux
  ]
}

resource "local_file" "windows_web_app_names_file" {
  count    = var.windows_webapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_windows_webapp_names)
  filename = "${path.module}/windows_web_app_names.txt"
  depends_on = [
    azurerm_windows_web_app.webapp_windows
  ]
}


resource "local_file" "linux_web_app_serviceplan" {
  content  = local.linux_serviceplan_names_from_file_length == 0 && local.elinux_plan_len == 0 ? join("\n", local.linux_app_service_plan_names) : fileexists("${path.module}/linux_web_app_serviceplan.txt") ? file("${path.module}/linux_web_app_serviceplan.txt") : ""
  filename = "${path.module}/linux_web_app_serviceplan.txt"
  depends_on = [
    azurerm_service_plan.asplinux
  ]
}

resource "local_file" "windows_web_app_serviceplan" {
  content  = local.windows_serviceplan_names_from_file_length == 0 && local.ewindows_plan_len == 0 ? join("\n", local.windows_app_service_plan_names) : fileexists("${path.module}/windows_web_app_serviceplan.txt") ? file("${path.module}/windows_web_app_serviceplan.txt") : ""
  filename = "${path.module}/windows_web_app_serviceplan.txt"
  depends_on = [
    azurerm_service_plan.aspwindows
  ]
}