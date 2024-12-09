## Instance Details

variable "geo_location" {
  type        = string
  description = "The name of the Azure region where the Cosmos DB account will be hosted and its replication priority."
  default     = false
}

variable "capacity_mode" {
  type        = bool
  description = "Indicates the capacity mode: Provisioned Throughput (true) or Serverless (false)."
  default     = false
}



variable "enable_throughput_limit" {
  description = "Flag to enable throughput limit for provisioned throughput in the Cosmos DB account."
  type        = bool
  default     = false
}

variable "total_throughput_limit" {
  type        = number
  default     = 400
  description = "Cosmos db database throughput"
  validation {
    condition     = var.total_throughput_limit >= 400 && var.total_throughput_limit <= 1000000
    error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.total_throughput_limit % 100 == 0
    error_message = "Cosmos db throughput should be in increments of 100."
  }
}



# Global Distribution

variable "multi_write_enabled" {
  description = "Flag to enable multiple write locations for this Cosmos DB account, allowing writes to be performed in multiple regions."
  type        = bool
  default     = false
}

# Network

variable "public_network_access_enabled" {
  description = "Flag to enable public network access for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "allow_access_from" {
  description = "Enable selected Network"
  type        = bool
  default     = true
}

variable "public_network_access_enabled_network_name" {
  description = "Network Name"
  type        = string
  default     = null
}


variable "resource_group_name_private_endpoint" {
  description = "Name of the existing resource group for network private endpoint."
  type        = string
  default     = null
}

variable "private_endpoint_network_name" {
  description = "Private Endpoint Network Name"
  type        = string
  default     = null
}



variable "resource_group_name_public_access" {
  description = "Name of the existing resource group for network public access."
  type        = string
  default     = null
}




variable "private_endpoint" {
  type        = bool
  description = "Flag to enable private endpoint connections to the Cosmos DB account."
  default     = false
}

# Backup Policy



variable "type" {
  description = "Specifies the type of backup: 'Periodic' or 'Continuous'."
  type        = string
  default     = "Periodic"
}

variable "tier" {
  description = "Defines the tier for continuous backups. Possible values are 'Continuous7Days' and 'Continuous30Days'."
  type        = string
  default     = "Continuous7Days"
}

variable "interval_in_minutes" {
  description = "The interval in minutes between two backups for periodic backups."
  type        = number
  default     = 240
}

variable "retention_in_hours" {
  description = "The retention period in hours for each backup."
  type        = number
  default     = 8
}

variable "storage_redundancy" {
  description = "Specifies the type of storage redundancy for backups, such as 'Geo' or 'Local'."
  type        = string
  default     = "Geo"
}

# CosmosDB variables

variable "consistency_level" {
  type        = string
  description = "The consistency level for the Cosmos DB account, e.g., 'Session', 'BoundedStaleness', 'Strong'."
  default     = "Session"
}

variable "max_interval_in_seconds" {
  description = "The maximum interval in seconds for bounded staleness consistency level."
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "The maximum staleness prefix for bounded staleness consistency level."
  type        = number
  default     = 100
}

variable "ignore_missing_vnet_service_endpoint" {
  description = "Flag to indicate whether to ignore missing virtual network service endpoints."
  type        = string
  default     = null
}

variable "kind" {
  description = "Specifies the kind of Cosmos DB to create. Default is 'GlobalDocumentDB'."
  type        = string
  default     = "GlobalDocumentDB"
}

variable "offer_type" {
  description = "Specifies the offer type for the Cosmos DB account, e.g., 'Standard'."
  type        = string
  default     = "standard"
}

variable "partition_key_path" {
  description = "Defines the partition key path for the Cosmos DB collections."
  type        = list(string)
  default     = ["/definition/id"]
}

variable "partition_key_version" {
  description = "Specifies the partition key version. Set to '2' for using large partition keys."
  default     = 1
}

variable "free_tier_enabled" {
  description = "Flag to enable the free tier for the Cosmos DB account."
  type        = bool
  default     = false
}

# Variable declarations for the Terraform configuration

variable "applicationname" {
  description = "The name of the application that will use the Cosmos DB account."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "The name of the existing resource group where the Cosmos DB account will be created."
  type        = string
  default     = null
}

variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "location" {
  description = "The location for the resource group."
  type        = string
  default     = null
}

variable "retention_days" {
  description = "The number of days for retention of managed instance security alert policies."
  type        = number
  default     = 30
}

variable "enable_advanced_threat_protection" {
  type        = bool
  description = "Flag to enable advanced threat protection for the Cosmos DB account."
  default     = false
}
variable "data_encryption_type" {
  type        = bool
  description = "Indicates the data encryption type for the Cosmos DB account."
  default     = false
}


variable "identity" {
  type        = bool
  description = "Indicates the default identity type for the Cosmos DB account."
  default     = false
}

# variable "identity_existing" {
#   type        = bool
#   description = "Indicates the existing user identity type for the Cosmos DB account."
#   default     = true
# }

variable "environment" {
  description = "The environment type (e.g., DEV, UAT, PROD) for the deployment."
  type        = string
  default     = "DEV"
}

variable "role_access" {
  description = "The email of the Azure AD user or the name of the Azure AD group to assign role access."
  type        = string
  default     = null
}

variable "custom_role_name" {
  description = "The name of the custom role to be assigned."
  type        = string
  default     = null
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU name for the Cosmos DB account."
  default     = "standard"
}

variable "create_new_key_vault" {
  description = "Set to true to create a new Key Vault, false to use an existing Key Vault."
  type        = bool
  default     = false
}

variable "key_vault_name" {
  description = "The name of the existing Key Vault to be used."
  type        = string
  default     = null
}

variable "create_new_key_key" {
  description = "Set to true to create a new Key , false to use an existing Key ."
  type        = bool
  default     = false
}

variable "key_name" {
  description = "The name of the existing key in the Key Vault."
  type        = string
  default     = null
}

variable "soft_delete_retention_days" {
  description = "The number of days for which the Key Vault's soft delete feature retains deleted items."
  type        = number
  default     = 7
}

variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user identity for accessing the Key Vault."
  type        = bool
  default     = false
}

variable "identity_name" {
  description = "The name of the user-assigned identity to be created or used."
  type        = string
  default     = null
}

variable "minimum_tls_version" {
  description = "Specifies the minimum TLS version required for connections to the Cosmos DB account."
  type        = string
  default     = "Tls12"
}

# Subscription Variables

variable "subscription_id" {
  sensitive   = true
  description = "The subscription ID for the Azure account."
}

variable "client_id" {
  sensitive   = true
  description = "The client ID for the Azure service principal."
}

variable "client_secret" {
  sensitive   = true
  description = "The client secret for the Azure service principal."
}

variable "tenant_id" {
  sensitive   = true
  description = "The tenant ID for the Azure Active Directory."
}

variable "rg_prefix" {
  type        = string
  description = "A prefix for naming resource groups."
  default     = null
}

####### Tags

variable "project_code" {
  description = "The project code associated with the resources."
  type        = string
  default     = null
}

variable "applicationid" {
  description = "The application ID for tracking and management purposes."
  type        = string
  default     = null
}

variable "costcenter" {
  description = "The cost center associated with the project or resource."
  type        = string
  default     = null
}

variable "dataclassification" {
  description = "The classification of data being stored in the Cosmos DB account."
  type        = string
  default     = null
}

variable "scaclassification" {
  description = "The SCA classification related to the project."
  type        = string
  default     = null
}

variable "iacrepo" {
  description = "The Infrastructure as Code (IaC) repository associated with the project."
  type        = string
  default     = null
}

variable "productowner" {
  description = "The owner of the product or application."
  type        = string
  default     = null
}

variable "productsupport" {
  description = "The support team responsible for the product."
  type        = string
  default     = null
}

variable "businessowner" {
  description = "The individual or team responsible for the business side of the project."
  type        = string
  default     = null
}

variable "csbia_availability" {
  description = "Availability score according to the CSBIA framework."
  type        = string
  default     = null
}

variable "csbia_confidentiality" {
  description = "Confidentiality score according to the CSBIA framework."
  type        = string
  default     = null
}

variable "csbia_impactscore" {
  description = "Impact score according to the CSBIA framework."
  type        = string
  default     = null
}

variable "csbia_integrity" {
  description = "Integrity score according to the CSBIA framework."
  type        = string
  default     = null
}

variable "businessopu_hcu" {
  description = "Business Operational Unit or Health Care Unit associated with the project."
  type        = string
  default     = null
}

variable "businessstream" {
  description = "The business stream that the project falls under."
  type        = string
  default     = null
}

