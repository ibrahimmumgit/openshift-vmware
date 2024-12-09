# Project and Resource Group Variables

variable "applicationname" {
  description = "Name of the project where the Azure Function App Service will be deployed."
  type        = string
  default     = null
}

variable "location" {
  description = "The Azure region where the resources will be deployed (e.g., East US, West Europe)."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment type for deployment (e.g., DEV, UAT, PROD)."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the existing resource group where resources will be deployed."
  type        = string
  default     = null
}

variable "create_new_resource_group" {
  description = "Boolean flag to indicate whether to create a new resource group."
  type        = bool
  default     = false
}

# Identity and Access Management Variables

variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user-assigned identity for the AKS cluster."
  type        = bool
  default     = false
}

variable "identity_access" {
  description = "Determines the type of identity access: System Assigned (true) or User Assigned (false)."
  type        = bool
  default     = false
}

variable "identity_name" {
  description = "Name of the user-assigned managed identity, if applicable."
  type        = string
  default     = null
}

# Monitoring and Logging Variables

variable "enable_monitoring" {
  description = "Flag to enable monitoring for the AKS cluster and related services."
  type        = bool
  default     = false
}

variable "create_new_application_insigts" {
  description = "Flag to indicate whether to create a new Application Insights instance."
  type        = bool
  default     = false
}

variable "sku" {
  description = "SKU tier for the Log Analytics Workspace (e.g., PerGB2018)."
  type        = string
  default     = "PerGB2018"
}

variable "existing_log_analytics_workspace" {
  description = "Name of the existing Log Analytics Workspace to be used."
  type        = string
  default     = null
}

# Networking Variables

variable "aks_vnet_network_name" {
  description = "The name of the Virtual Network to associate with the AKS cluster for private networking."
  type        = string
  default     = null
}

variable "resource_group_name_aks_vnet" {
  description = "The name of the resource group where the AKS VNet is located."
  type        = string
  default     = null
}

# AKS Cluster Variables

variable "zones" {
  description = "Number of availability zones for AKS nodes, if supported."
  type        = number
}

variable "sku_tier" {
  description = "The SKU tier for the resource, such as 'Free', 'Basic', 'Standard', etc."
  type        = string
  default     = "Standard" # You can set a default value or leave it empty
}


variable "kubernetes_version" {
  description = "The Kubernetes version to deploy on AKS."
  type        = string
  default     = "1.29.9"
}

variable "node_os_upgrade_channel" {
  description = "The upgrade channel for the OS on AKS nodes (e.g., NodeImage)."
  type        = string
  default     = "NodeImage"
}



variable "enable_rbac" {
  description = "Enable Role-Based Access Control (RBAC) on the AKS cluster."
  type        = bool
  default     = false
}

variable "group_name" {
  description = "Name of the Azure AD group to assign for RBAC in the AKS cluster."
  type        = string
  default     = null
}

variable "enable_http_application_routing" {
  description = "Flag to enable HTTP application routing on the AKS cluster."
  type        = bool
  default     = false
}

#node pools
variable "node_pool_name" {
  description = "Name of the node pool."
  type        = string
}

variable "os_sku" {
  description = "OS SKU for the AKS nodes (e.g., Ubuntu)."
  type        = string
  default     = "Ubuntu"
}



variable "node_vm_size" {
  description = "VM size for the AKS nodes (e.g., Standard_DS2_v2)."
  type        = string
  default     = "Standard_DS2_v2"
}



variable "auto_scaler_profile_min_count" {
  description = "Minimum node count for the AKS autoscaler."
  type        = number
  default     = 3
}

variable "auto_scaler_profile_max_count" {
  description = "Maximum node count for the AKS autoscaler."
  type        = number
  default     = 10
}

# variable "linux_admin_username" {
#   description = "Admin username for Linux nodes in the AKS cluster."
#   type        = string
#   default     = "azureuser"
# }

# variable "linux_ssh_public_key" {
#   description = "SSH public key for Linux admin access on AKS nodes."
#   type        = string
#   default     = "ssh-rsa AAAA..." # Provide SSH public key here
# }

# NGINX Deployment Variable

variable "nginx" {
  description = "Flag to indicate whether to deploy NGINX on the AKS cluster."
  type        = bool
  default     = false
}

# Subscription and Authentication Variables

variable "subscription_id" {
  description = "Azure subscription ID."
  sensitive   = true
}

variable "client_id" {
  description = "Azure client ID for authentication."
  sensitive   = true
}

variable "client_secret" {
  description = "Azure client secret for authentication."
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID for authentication."
  sensitive   = true
}

# Prefix and Role Variables

variable "rg_prefix" {
  description = "Prefix for the resource group name."
  type        = string
  default     = null
}

variable "role_access" {
  description = "Azure AD user email or group name to assign role access to."
  type        = string
  default     = null
}

variable "custom_role_name" {
  description = "Name of the custom role for access control."
  type        = string
  default     = null
}

# Tagging Variables

variable "project_code" {
  description = "Unique code identifying the project."
  type        = string
  default     = null
}

variable "applicationid" {
  description = "Unique identifier for the application."
  type        = string
  default     = null
}

variable "costcenter" {
  description = "Cost center for billing and financial tracking."
  type        = string
  default     = null
}

variable "dataclassification" {
  description = "Data classification level (e.g., Public, Confidential)."
  type        = string
  default     = null
}

variable "scaclassification" {
  description = "Security classification (e.g., High, Medium, Low)."
  type        = string
  default     = null
}

variable "iacrepo" {
  description = "Infrastructure as Code (IAC) repository URL."
  type        = string
  default     = null
}

variable "productowner" {
  description = "Name of the product owner responsible for the application."
  type        = string
  default     = null
}

variable "productsupport" {
  description = "Name of the team responsible for product support."
  type        = string
  default     = null
}

variable "businessowner" {
  description = "Name of the business owner responsible for the application."
  type        = string
  default     = null
}

variable "csbia_availability" {
  description = "Availability classification under CSBIA (Corporate Security Baseline Impact Assessment)."
  type        = string
  default     = null
}

variable "csbia_confidentiality" {
  description = "Confidentiality classification under CSBIA."
  type        = string
  default     = null
}

variable "csbia_impactscore" {
  description = "Impact score under CSBIA."
  type        = string
  default     = null
}

variable "csbia_integrity" {
  description = "Integrity classification under CSBIA."
  type        = string
  default     = null
}

variable "businessopu_hcu" {
  description = "Business OPU/HCU (Operating or Holding Corporate Unit) associated with the application."
  type        = string
  default     = null
}

variable "businessstream" {
  description = "Business stream associated with the application."
  type        = string
  default     = null
}
