# Variable declarations for the Terraform configuration

variable "applicationname" {
  description = "Name of the Project where the Azure webtionApp Service will be deployed."
  type        = string
  default     = null
}

variable "location" {
  description = "Resource group location"
  type        = string
  default     = null

}

variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)"
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




variable "linux_webapp_count" {
  description = "Number of Linux webtion Apps to create."
  type        = number
  default     = 0
}

variable "windows_webapp_count" {
  description = "Number of Windows webtion Apps to create."
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
  description = "The size of the SKU for the Linux webtion App Service Plan."
  type        = string
  default     = null

}

variable "sku_size_windows" {
  description = "The size of the SKU for the Windows webtion App Service Plan."
  type        = string
  default     = null

}

variable "runtime_stack_linux" {
  description = "The runtime stack for the Azure Linux webtion App (e.g., node, dotnet, java, powershell ,python )"
  type        = string
  default     = null
}

variable "runtime_version_linux" {
  description = "The runtime version for the Azure Linux webtion App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = null
}

variable "runtime_stack_windows" {
  description = "The runtime stack for the Azure Windows webtion App (e.g., node, dotnet, java, powershell)"
  type        = string
  default     = null
}

variable "runtime_version_windows" {
  description = "The runtime version for the Azure Windows webtion App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = null
}


variable "retention_in_days" {
  description = "Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 30."
  type        = number
  default     = 30
}



variable "backup_enable" {
  description = "# Whether to enable backups for the Web App."
  type        = bool
  default     = false
}

variable "storage_account_name" {
  description = "Name of the existing storage account."
  type        = string
  default     = null

}

variable "storage_account_resource_group_name" {
  description = "Name of the resource group for the existing storage account."
  type        = string
  default     = null

}


variable "account_replication_type" {
  description = "Storage account replication type. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
  default     = null

}

variable "account_kind" {
  description = "Storage account kind. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  type        = string
  default     = "StorageV2"

}

variable "account_tier" {
  description = "Storage account tier. Valid options are Standard and Premium."
  type        = string
  default     = null

}

variable "zone_redundant" {
  description = "Enable zone redundancy if the environment is production."
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Flag to indicate whether to enable monitoring."
  type        = bool
  default     = false

}

variable "create_new_application_insigts" {
  description = "Flag to indicate whether to create a new Application Insights instance."
  type        = bool
  default     = false

}

variable "sku" {
  description = "The SKU for the Log Analytics Workspace"
  type        = string
  default     = null
}
variable "application_insights_name" {
  description = "Name of the existing Application Insights instance."
  type        = string
  default     = null

}

variable "application_insights_resource_group_name" {
  description = "Name of the resource group for the existing Application Insights instance."
  type        = string
  default     = null

}

variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user identity."
  type        = bool
  default     = false
}


variable "identity_access" {
  description = "Name of identity access"
  type        = string
  default     = "SystemAssigned" # Set this to the name of the user-assigned identity if needed
}

variable "identity_name" {
  description = "Name of the user-assigned identity"
  type        = string
  default     = null # Set this to the name of the user-assigned identity if needed
}

variable "identity_name_resource_group_name" {
  description = "Name of the resource group for the existing identity name."
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

variable "enable_redis_cache" {
  description = "Flag to indicate whether to Enable the redis cache."
  type        = bool
  default     = false
}

variable "frequency_interval" {
  description = "How often the backup should be executed."
  type        = number
  default     = 30
}


#subscription
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