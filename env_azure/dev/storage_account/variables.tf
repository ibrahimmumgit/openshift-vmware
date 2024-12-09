variable "applicationname" {
  description = "Name of the Project where the storage account will be deployed. Changing this value will recreate the storage account."
  type        = string
  default     = null
}

variable "location" {
  description = "Resource group location. Changing this value will recreate all resources within the resource group."
  type        = string
  default     = null
}

variable "environment" {
  description = "The Environment type (E.g., DEV, UAT, PROD). This value is typically used for tagging and will not recreate resources unless explicitly referenced in resource names."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the existing resource group. Changing this value will result in the creation of resources in a different group but will not directly recreate them."
  type        = string
  default     = null
}

variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group. Changing this value will recreate the resource group and associated resources."
  type        = bool
  default     = false
}

variable "account_replication_type" {
  description = "Storage account replication type. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RAGZRS. Changing this value will recreate the storage account."
  type        = string
  default     = null
}

variable "account_kind" {
  description = "Storage account kind. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage, and StorageV2. Changing this value will recreate the storage account."
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Storage account tier. Valid options are Standard and Premium. Changing this value will recreate the storage account."
  type        = string
  default     = null
}

variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user identity. "
  type        = bool
  default     = true
}

variable "identity_access" {
  description = "SystemAssigned or UserAssigned identity type. Changing this value will recreate resources using this identity."
  type        = bool
  default     = false
}

variable "role_access" {
  description = "The email of the Azure AD user or the name of the Azure AD group to assign the role to."
  type        = string
  default     = null
}

variable "default_action" {
  description = "Specifies the default action of allow or deny when no other rules match. "
  type        = string
  default     = "Deny"
}

variable "blob_versioning_enabled" {
  description = "Enable blob versioning. "
  type        = bool
  default     = true
}

variable "blob_delete_retention_days" {
  description = "Days to retain deleted blobs. "
  type        = number
  default     = 7
}

variable "create_container" {
  description = "Boolean to determine if a storage container should be created. "
  type        = bool
  default     = false
}

variable "quota" {
  description = "Quota for the file share in GB. "
  type        = number
  default     = null
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