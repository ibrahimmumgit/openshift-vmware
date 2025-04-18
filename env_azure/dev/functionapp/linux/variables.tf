# Variable declarations for the Terraform configuration

variable "applicationname" {
  description = "Name of the Project where the Azure FunctionApp Service will be deployed."
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



variable "create_new_service_plan" {
  description = "Flag to indicate whether to create a new service plan."
  type        = bool
  default     = false
}

variable "serviceplan_name" {
  description = "Name of the existing service plan."
  type        = string
  default     = null
}

variable "linux_funcapp_count" {
  description = "Number of Linux Function Apps to create."
  type        = number
  default     = 1
}

variable "linux_instance_count" {
  description = "Number of Linux instances for scaling."
  type        = number
  default     = 0

}


variable "sku_size_linux" {
  description = "The size of the SKU for the Linux Function App Service Plan."
  type        = string
  default     = "B1"

}



variable "runtime_stack_linux" {
  description = "The runtime stack for the Azure Linux Function App (e.g., node, dotnet, java, powershell ,python )"
  type        = string
  default     = null
}

variable "runtime_version_linux" {
  description = "The runtime version for the Azure Linux Function App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = null
}




variable "create_storage_account" {
  description = "Flag to indicate whether to create a new storage account."
  type        = bool
  default     = false
}

variable "storage_account_name" {
  description = "Name of the existing storage account."
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
  default     = "PerGB2018"
}
variable "application_insights_name" {
  description = "Name of the existing Application Insights instance."
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
  default     = "SystemAssigned, UserAssigned" # Set this to the name of the user-assigned identity if needed
}

variable "identity_name" {
  description = "Name of the user-assigned identity"
  type        = string
  default     = null # Set this to the name of the user-assigned identity if needed
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



