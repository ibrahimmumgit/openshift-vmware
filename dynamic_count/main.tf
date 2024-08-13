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
    if [ -f total_count.txt ]; then
      total_count=$(cat total_count.txt)
    else
      total_count=0
    fi

    total_count=$((total_count + ${var.linux_app_count} + ${var.windows_app_count}))
    echo $total_count > total_count.txt
  EOT
}
}

output "total_count" {
  value = file("total_count.txt")
}
