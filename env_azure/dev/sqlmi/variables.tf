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

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for the SQL Managed Instance."
  default     = "GP_Gen5"
}
 
variable "license_type" {
  type        = string
  description = "What type of license the Managed Instance will use."
  default     = "BasePrice"
}
 
variable "vcores" {
  type        = number
  description = "Number of cores that should be assigned."
  default     = 8
}
 
variable "storage_size_in_gb" {
  type        = number
  description = "Maximum storage space for the SQL Managed instance."
  default     = 32
}


 
variable "sql_vnet_network_name" {
  description = "Private Endpoint Network Name"
  type        = string
  default     = null
}

variable "resource_group_name_sql_vnet" {
  description = "Name of the existing resource group for network private endpoint."
  type        = string
  default     = null
}

variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)."
  type        = string
  default     = "DEV"
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database."
  type        = string
  default     = "ZRS"
}

variable "timezone_id" {
  type        = string
  description = "The TimeZone ID that the SQL Managed Instance will be operating in"
  default     = "Singapore Standard Time"
}

## SQL Authentication or Entra ID by default it is SQL Auth
variable "sql_authentication" {
  description = "Do you want to use existing Entra ID or new for sqlmi authentication."
  type        = bool
  default     = true
}




# UAI
variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user identity."
  type        = bool
  default     = false
}

variable "identity_access" {
  description = "Select System Assigned or User assigned identity access"
  type        = bool
  default     = false 
}

variable "identity_name" {
  description = "Name of the user-assigned identity"
  type        = string
  default     = null # Set this to the name of the user-assigned identity if needed
}

variable "use_custom_key" {
  description = "Set this as 'true' to use a customer managed key, 'false' for system-managed key."
  type        = bool
  default     = false
}


variable "create_new_key_vault" {
  description = "Set to true to create a new Key Vault, false to use an existing Key Vault."
  type        = bool
  default     = false
}

variable "key_vault_name" {
  description = "Name of the existing Key Vault."
  type        = string
  default     = null
}





variable "public_data_endpoint_enabled" {
  type        = string
  description = "Enter false/true if public data endpoint to be enabled"
  default     = false
}



variable "zone_redundant" {
  description = "Enable zone redundancy if the environment is production."
  type        = bool
  default     = false
}


# Role Access

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


# Default Values
variable "administrator_login" {
  type        = string
  description = "Enter the sqlmi admin username."
  default     = "sqladmin"
}


variable "sku_name_kv" {
  description = "The sku_name_ for key vault."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "The soft delete retention days for key vault ."
  type        = number
  default     = 90
}

variable "retention_days" {
  description = "The retentation days for managed instance security alert policy."
  type        = number
  default     = 30
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

