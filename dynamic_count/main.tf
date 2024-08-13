variable "linux_app_count" {
  default = 2
}

variable "windows_app_count" {
  default = 2
}

resource "null_resource" "update_total_count" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      if exist total_count.txt (
        set /p total_count=<total_count.txt
      ) else (
        set total_count=0
      )

      set /a total_count=%total_count% + ${var.linux_app_count} + ${var.windows_app_count}
      echo %total_count% > total_count.txt
    EOT
  }
}

output "total_count" {
  value = file("total_count.txt")
}
