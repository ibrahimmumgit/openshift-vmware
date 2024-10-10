variable "security_group_string" {
  description = "Security group string in JSON-like format"
  type        = string
}


# Variable declarations for the Terraform configuration

variable "applicationname" {
  description = "Name of the Project where the Azure FunctionApp Service will be deployed."
  type        = string
  default     = "test"
}

variable "location" {
  description = "Resource group location"
  type        = string
  default     = "test"

}

variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)"
  type        = string
  default     = "test"

}

variable "resource_group_name" {
  description = "Name of the existing resource group."
  type        = string
  default     = "test"
}
variable "resource_group_name1" {
  description = "Name of the existing resource group."
  type        = string

}

variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group."
  type        = bool
  default     = false
}




variable "linux_funcapp_count" {
  description = "Number of Linux Function Apps to create."
  type        = number
  default     = 1
}

variable "windows_funcapp_count" {
  description = "Number of Windows Function Apps to create."
  type        = number
  default     = 0
}
variable "linux_instance_count" {
  description = "Number of Linux instances for scaling."
  type        = number
  default     = 0

}

variable "windows_instance_count" {
  description = "Number of Windows instances for scaling."
  type        = number
  default     = 0

}

variable "sku_size_linux" {
  description = "The size of the SKU for the Linux Function App Service Plan."
  type        = string
  default     = "test"

}

variable "sku_size_windows" {
  description = "The size of the SKU for the Windows Function App Service Plan."
  type        = string
  default     = "test"

}

variable "runtime_stack_linux" {
  description = "The runtime stack for the Azure Linux Function App (e.g., node, dotnet, java, powershell ,python )"
  type        = string
  default     = "test"
}

variable "runtime_version_linux" {
  description = "The runtime version for the Azure Linux Function App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = "test"
}

variable "runtime_stack_windows" {
  description = "The runtime stack for the Azure Windows Function App (e.g., node, dotnet, java, powershell)"
  type        = string
  default     = "test"
}

variable "runtime_version_windows" {
  description = "The runtime version for the Azure Windows Function App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = "test"
}


variable "create_storage_account" {
  description = "Flag to indicate whether to create a new storage account."
  type        = bool
  default     = true
}

variable "storage_account_name" {
  description = "Name of the existing storage account."
  type        = string
  default     = "test"

}

variable "storage_account_resource_group_name" {
  description = "Name of the resource group for the existing storage account."
  type        = string
  default     = "test"

}


variable "account_replication_type" {
  description = "Storage account replication type. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
  default     = "test"

}

variable "account_kind" {
  description = "Storage account kind. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  type        = string
  default     = "StorageV2"

}

variable "account_tier" {
  description = "Storage account tier. Valid options are Standard and Premium."
  type        = string
  default     = "test"

}

variable "zone_redundant" {
  description = "Enable zone redundancy if the environment is production."
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Flag to indicate whether to enable monitoring."
  type        = bool
  default     = true

}

variable "create_new_application_insigts" {
  description = "Flag to indicate whether to create a new Application Insights instance."
  type        = bool
  default     = true

}

variable "sku" {
  description = "The SKU for the Log Analytics Workspace"
  type        = string
  default     = "test"
}
variable "application_insights_name" {
  description = "Name of the existing Application Insights instance."
  type        = string
  default     = "test"

}

variable "application_insights_resource_group_name" {
  description = "Name of the resource group for the existing Application Insights instance."
  type        = string
  default     = "test"

}

variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user identity."
  type        = bool
  default     = true
}


variable "identity_access" {
  description = "Name of identity access"
  type        = string
  default     = "SystemAssigned, UserAssigned" # Set this to the name of the user-assigned identity if needed
}

variable "identity_name" {
  description = "Name of the user-assigned identity"
  type        = string
  default     = "test" # Set this to the name of the user-assigned identity if needed
}

variable "identity_name_resource_group_name" {
  description = "Name of the resource group for the existing identity name."
  type        = string
  default     = "test"

}

variable "role_access" {
  description = "The email of the Azure AD user or the name of the Azure AD group to assign the role to."
  type        = string
  default     = "test"
}

variable "custom_role_name" {
  description = "Custom Role name"
  type        = string
  default     = "test"
}




variable "rg_prefix" {
  default = null
}


#######tags
variable "project_code" {
  description = "The project code"
  type        = string
  default     = "test"
}

variable "applicationid" {
  description = "The application ID"
  type        = string
  default     = "test"
}

variable "costcenter" {
  description = "The cost center"
  type        = string
  default     = "test"
}

variable "dataclassification" {
  description = "The data classification"
  type        = string
  default     = "test"
}

variable "scaclassification" {
  description = "The SCA classification"
  type        = string
  default     = "test"
}

variable "iacrepo" {
  description = "The IAC repository"
  type        = string
  default     = "test"
}

variable "productowner" {
  description = "The product owner"
  type        = string
  default     = "test"
}

variable "productsupport" {
  description = "The product support team"
  type        = string
  default     = "test"
}

variable "businessowner" {
  description = "The business owner"
  type        = string
  default     = "test"
}

variable "csbia_availability" {
  description = "CSBIA Availability"
  type        = string
  default     = "test"
}

variable "csbia_confidentiality" {
  description = "CSBIA Confidentiality"
  type        = string
  default     = "test"
}

variable "csbia_impactscore" {
  description = "CSBIA Impact Score"
  type        = string
  default     = "test"
}

variable "csbia_integrity" {
  description = "CSBIA Integrity"
  type        = string
  default     = "test"
}

variable "businessopu_hcu" {
  description = "Business OPU/HCU"
  type        = string
  default     = "test"
}

variable "businessstream" {
  description = "The business stream"
  type        = string
  default     = "test"
}

variable "srnumber" {
  description = "The SR number"
  type        = string
  default     = "test"
}


