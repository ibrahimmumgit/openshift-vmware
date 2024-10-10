


locals {
  # Clean up the string to extract the security group IDs
  security_group_ids = [
    for sg in split(", ", replace(replace(var.security_group_string, "[", ""), "]", "")) : 
    trimspace(replace(replace(sg, "{id=", ""), "}", ""))
  ]
}

output "security_group_ids" {
  value = local.security_group_ids
}

