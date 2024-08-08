# Variable declarations for the Terraform configuration

variable "projectname" {
  description = "Name of the Project where the Azure App Service will be deployed."
  type        = string

}

variable "location" {
  description = "Resource group location"
  type        = string

}

variable "sku_size_linux" {
  description = "The size of the SKU for the Linux Function App Service Plan."
  type        = string
  default     = ""

}

variable "sku_size_windows" {
  description = "The size of the SKU for the Windows Function App Service Plan."
  type        = string
  default     = ""

}

variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)"
  type        = string
  default     = ""

}

variable "account_replication_type" {
  description = "Storage account replication type. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
  default     = ""

}

variable "account_kind" {
  description = "Storage account kind. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  type        = string
  default     = "StorageV2"

}

variable "account_tier" {
  description = "Storage account tier. Valid options are Standard and Premium."
  type        = string
  default     = ""

}

variable "resource_group_name" {
  description = "Name of the existing resource group."
  type        = string
  default     = ""

}

variable "linux_funcapp_count" {
  description = "Number of Linux Function Apps to create."
  type        = number
  default     = 0
}

variable "windows_funcapp_count" {
  description = "Number of Windows Function Apps to create."
  type        = number
  default     = 0
}

variable "zone_redundant" {
  description = "Enable zone redundancy if the environment is production."
  type        = bool
  default     = false
}

variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group."
  type        = bool
  default     = true
}

variable "create_storage_account" {
  description = "Flag to indicate whether to create a new storage account."
  type        = bool
  default     = true
}

variable "storage_account_name" {
  description = "Name of the existing storage account."
  type        = string
  default     = ""

}

variable "storage_account_resource_group_name" {
  description = "Name of the resource group for the existing storage account."
  type        = string
  default     = ""

}

variable "enable_monitoring" {
  description = "Flag to indicate whether to enable monitoring."
  type        = bool
  default     = false

}

variable "create_new_application_insigts" {
  description = "Flag to indicate whether to create a new Application Insights instance."
  type        = bool
  default     = true

}

variable "application_insights_name" {
  description = "Name of the existing Application Insights instance."
  type        = string
  default     = ""

}

variable "application_insights_resource_group_name" {
  description = "Name of the resource group for the existing Application Insights instance."
  type        = string
  default     = ""

}

variable "linux_instance_count" {
  description = "Number of Linux instances for scaling."
  type        = number
  default     = 1

}

variable "windows_instance_count" {
  description = "Number of Windows instances for scaling."
  type        = number
  default     = 1

}

variable "app_service_plan" {
  description = "Flag to indicate whether to create a Shared service plan or Separate."
  type        = string
  default     = "separate"
}

variable "role_access" {
  description = "The email of the Azure AD user or the name of the Azure AD group to assign the role to."
  type        = string
  default     = null
}


variable "sku" {
  description = "The SKU for the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}


variable "runtime_stack_linux" {
  description = "The runtime stack for the Azure Linux Function App (e.g., node, python, dotnet, java, powershell)"
  type        = string
  default     = null
}

variable "runtime_version_linux" {
  description = "The runtime version for the Azure Linux Function App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = null
}

variable "runtime_stack_windows" {
  description = "The runtime stack for the Azure Windows Function App (e.g., node, python, dotnet, java, powershell)"
  type        = string
  default     = null
}

variable "runtime_version_windows" {
  description = "The runtime version for the Azure Windows Function App (e.g., 18, 3.9, 6.0, 11)"
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
