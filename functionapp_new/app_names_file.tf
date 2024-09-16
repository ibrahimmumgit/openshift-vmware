# Resource to write the function app names to a file
resource "local_file" "linux_function_app_names_file" {
  count    = var.linux_funcapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_linux_funcapp_names)
  filename = "${path.module}/linux_function_app_names.txt"
}



resource "local_file" "windows_function_app_names_file" {
  count    = var.windows_funcapp_count > 0 ? 1 : 0
  content  = join("\n", local.truncated_windows_funcapp_names)
  filename = "${path.module}/windows_function_app_names.txt"
}

resource "local_file" "linux_function_app_serviceplan" {
  content  = local.linux_serviceplan_names_from_file_length == 0 && local.elinux_plan_len == 0 ? join("\n", local.linux_app_service_plan_names) : fileexists("${path.module}/linux_function_app_serviceplan.txt") ? file("${path.module}/linux_function_app_serviceplan.txt") : ""
  filename = "${path.module}/linux_function_app_serviceplan.txt"
}

resource "local_file" "windows_function_app_serviceplan" {
  content  = local.windows_serviceplan_names_from_file_length == 0 && local.ewindows_plan_len == 0 ? join("\n", local.windows_app_service_plan_names) : fileexists("${path.module}/windows_function_app_serviceplan.txt") ? file("${path.module}/windows_function_app_serviceplan.txt") : ""
  filename = "${path.module}/windows_function_app_serviceplan.txt"
}