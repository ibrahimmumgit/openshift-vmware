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

variable "windows_funcapp_count" {
  description = "Number of windows Function Apps to create."
  type        = number
  default     = 1
}

variable "windows_instance_count" {
  description = "Number of windows instances for scaling."
  type        = number
  default     = 0

}


variable "sku_size_windows" {
  description = "The size of the SKU for the windows Function App Service Plan."
  type        = string
  default     = "B1"

}



variable "runtime_stack_windows" {
  description = "The runtime stack for the Azure windows Function App (e.g., node, dotnet, java, powershell ,python )"
  type        = string
  default     = null
}

variable "runtime_version_windows" {
  description = "The runtime version for the Azure windows Function App (e.g., 18, 3.9, 6.0, 11)"
  type        = string
  default     = null
}




variable "create_storage_account" {
  description = "Flag to indicate whether to create a new storage account."
  type        = bool
  default     = true
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

variable "srnumber" {
  description = "The SR number"
  type        = string
  default     = null
}


