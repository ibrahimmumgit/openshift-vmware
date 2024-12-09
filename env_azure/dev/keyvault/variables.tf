# Variable declarations for the Terraform configuration

variable "applicationname" {
  description = "Name of the application."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the existing resource group."
  type        = string
  default     = null
}


variable "resource_group_name_public_access" {
  description = "Name of the existing resource group for network public access."
  type        = string
  default     = null
}

variable "resource_group_name_private_endpoint" {
  description = "Name of the existing resource group for network private endpoint."
  type        = string
  default     = null
}




variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group."
  type        = bool
  default     = false
}

variable "location" {
  description = "Resource group location"
  type        = string
  default     = null
}

variable "enabled_for_deployment" {
  description = "Enabled for deployment"
  type        = bool
  default     = false

}
variable "enabled_for_disk_encryption"{
  description = "Enable disk encryption"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment"{
  description = "Enable template deployment"
  type        = bool
  default     = false
}

variable "rbac_authorization"{
  description = "Enable rbac authorization"
  type        = bool
  default     = false
}

variable "purge_protection" {
  description = "Enable purge_protection_enabled"
  type        = bool
  default     = false
}

variable "public_network_access_enabled"{
  description = "Enable rbac authorization"
  type        = bool
  default     = false
}

variable "allow_access_from"{
  description = "Enable selected Network"
  type        = bool
  default     = false
}


variable "public_network_access_enabled_network_name"{
  description = "Network Name"
  type        = string
  default     = null
}


variable "private_endpoint_network_name"{
  description = "Private Endpoint Network Name"
  type        = string
  default     = null
}

variable "integrate_with_private_dns_zone"{
  description = "Integrate with private dns zone"
  type        = bool
  default     = false
}


variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for the SQL Managed Instance."
  default     = "standard"
}
 
// variable "allowed_ip_addresses" {
//   type        = list(string)
//   description = "IP rules to allow or deny."
//   default     = []
// }

variable "bypass" {
  type        = string
  description = "Bypass network_acls."
  default     = "None"
}

// variable "virtual_network_subnet_ids" {
//   type        = list(string)
//   description = "The subnet id to allow network access."
//   default     = []
// }

// variable "subnet_id" {
//   type        = string
//   description = "The subnet resource id to enable private endpoint."
//   default     = null
// }

variable "private_endpoint" {
  type        = bool
  description = "Enable private endpoint connection."
  default     = true
}

variable "private_dns_zone_ids" {
  description = "To connect privately with your private endpoint, you need a DNS record."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)."
  type        = string
  default     = "DEV"
}

variable "key_permissions_level" {
  type    = string
  default = "basic"
  description = <<EOT
Set the key permissions level. Possible values:
- basic: ["Get", "List"]
- intermediate: ["Get", "List", "Encrypt", "Decrypt", "WrapKey", "UnwrapKey"]
- advanced: ["Get", "List", "Encrypt", "Decrypt", "WrapKey", "UnwrapKey", "Sign", "Verify", "Backup", "Restore", "Purge", "Delete", "Update", "Create", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
EOT
}


variable "secret_permissions_level" {
  type    = string
  default = "basic"
  description = <<EOT
Set the secret permissions level. Possible values:
- basic: ["Get", "List"]
- intermediate: ["Get", "List", "Set", "Delete"]
- advanced: ["Get", "List", "Set", "Delete", "Backup", "Restore", "Purge", "Recover"]
EOT
}

variable "access_policy_group_name" {
  description = "The name of the Azure AD group to assign the role to access policy."
  type        = string
  default     = null
}


variable "role_access" {
  description = "The email of the Azure AD user or the name of the Azure AD group to assign the role to."
  type        = string
  default     = null
}

variable "custom_role_name" {
  description = "Custom Role name"
  type        = string
  default     = null
}

variable "default_action" {
  description = "Default action for Network ACLS allow or Deny."
  type        = string
  default     = "Allow"
}


variable "soft_delete_retention_days" {
  description = "The soft delete retention days for key vault ."
  type        = number
  default     = 90
}


#subscription
variable "subscription_id" {
  sensitive = true
}

variable "client_id" {
  sensitive = true
}

variable "client_secret" {
  sensitive = true
}

variable "tenant_id" {
  sensitive = true 
}

variable "rg_prefix" {
  type = string
  default = null
}


#######tags
variable "project_code" {
  description = "The project code"
  type        = string
  default     = null
}

variable "applicationid" {
  description = "The application ID"
  type        = string
  default     = null
}

variable "costcenter" {
  description = "The cost center"
  type        = string
  default     = null
}

variable "dataclassification" {
  description = "The data classification"
  type        = string
  default     = null
}

variable "scaclassification" {
  description = "The SCA classification"
  type        = string
  default     = null
}

variable "iacrepo" {
  description = "The IAC repository"
  type        = string
  default     = null
}

variable "productowner" {
  description = "The product owner"
  type        = string
  default     = null
}

variable "productsupport" {
  description = "The product support team"
  type        = string
  default     = null
}

variable "businessowner" {
  description = "The business owner"
  type        = string
  default     = null
}

variable "csbia_availability" {
  description = "CSBIA Availability"
  type        = string
  default     = null
}

variable "csbia_confidentiality" {
  description = "CSBIA Confidentiality"
  type        = string
  default     = null
}

variable "csbia_impactscore" {
  description = "CSBIA Impact Score"
  type        = string
  default     = null
}

variable "csbia_integrity" {
  description = "CSBIA Integrity"
  type        = string
  default     = null
}

variable "businessopu_hcu" {
  description = "Business OPU/HCU"
  type        = string
  default     = null
}

variable "businessstream" {
  description = "The business stream"
  type        = string
  default     = null
}

