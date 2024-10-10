

variable "security_group_string" {
  description = "Security group string in JSON-like format"
  type        = string
}


variable "key_permissions" {
  description = "Key Vault key permissions"
  type        = list(string)

}

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

output "key_permissions" {
  value = var.key_permissions
}

