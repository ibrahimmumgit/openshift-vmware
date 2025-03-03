# --- Variable Declarations for Terraform Configuration ---

# The name of the application or project where the Azure FunctionApp Service will be deployed.
variable "applicationname" {
  description = "Name of the Project where the Azure Windows VM will be deployed."
  type        = string
  default     = null
}

variable "applicationtype" {
  description = "Type of the application where the Azure Windows VM will be deployed."
  type        = string
  default     = null
}

# The location where the resource group will be created in Azure (e.g., 'East US', 'West Europe').
variable "location" {
  description = "Resource group location."
  type        = string
  default     = null
}

# The environment type for the resources (e.g., DEV, UAT, PROD).
variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)."
  type        = string
  default     = null
}

# The name of an existing resource group in which resources will be deployed.
variable "resource_group_name" {
  description = "Name of the existing resource group."
  type        = string
  default     = null
}

# Flag to specify whether to create a new resource group (true) or use an existing one (false).
variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group."
  type        = bool
  default     = false
}


# The administrator username for the Virtual Machine (VM) to be created.
variable "admin_username" {
  description = "Username for Virtual Machine administrator account."
  type        = string
  default     = "manager"
}

variable "admin_password"{
  description = "Passwordrtual Machine administrator account."
  type        = string
  sensitive   = true
  default     = "Password!234"
}



# The size (SKU) of the Virtual Machine to be created (e.g., 'Standard_DS2_v2').
variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
  default     = "Standard_F2"
}


variable "vm_image_publisher" {
  description = "The publisher of the image to be used for the Virtual Machine (e.g., MicrosoftWindowsServer)."
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "vm_image_offer" {
  description = "The offer of the image to be used for the Virtual Machine (e.g., WindowsServer)."
  type        = string
  default     = "WindowsServer"
}

variable "vm_image_sku" {
  description = "The SKU of the image to be used for the Virtual Machine (e.g., 2016-Datacenter)."
  type        = string
  default     = "2016-Datacenter"
}

variable "vm_image_version" {
  description = "The version of the image to be used for the Virtual Machine (e.g., latest)."
  type        = string
  default     = "latest"
}





# Specifies the number of data disks to be created for the Virtual Machine.

variable "create_new_data_disk" {
  description = "Set to true to create a new data disk."
  type        = bool
  default     = false
}

variable "data_disk_count" {
  description = "Specifies the number of Data Disks to be created."
  type        = number
  default     = 1
}






# Specifies the size of each data disk in gigabytes (GB).
variable "data_disk_size" {
  description = "Specifies the Data Disk size to be created."
  type        = number
  default     = 128
}


# Networking Variables

variable "vm_vnet_network_name" {
  description = "The name of the Virtual Network."
  type        = string
  default     = null
}

variable "resource_group_name_vm_vnet" {
  description = "The name of the resource group where the AKS VNet is located."
  type        = string
  default     = null
}



# --- Azure Subscription Details ---
variable "subscription_id" {
  sensitive   = true
  description = "The Azure subscription ID."
}

variable "client_id" {
  sensitive   = true
  description = "The client ID for Azure service principal."
}

variable "client_secret" {
  sensitive   = true
  description = "The client secret for Azure service principal."
}

variable "tenant_id" {
  sensitive   = true
  description = "The Azure tenant ID."
}

# --- Resource Group Prefix ---
variable "rg_prefix" {
  description = "Prefix for naming resources in the Resource Group."
  default     = null
}

# --- Tags for Resource Classification ---
variable "appid" {
  description = "The application ID."
  type        = string
  default = null
}

variable "appsupport" {
  description = "The application support contact or details."
  type        = string
  default = null
}

variable "criticality" {
  description = "The criticality level of the application."
  type        = string
  default = null
}

variable "disasterrecovery" {
  description = "Disaster recovery details or strategy."
  type        = string
  default = null
}

variable "rpo" {
  description = "Recovery Point Objective (RPO) for the application."
  type        = string
  default = null
}

variable "rto" {
  description = "Recovery Time Objective (RTO) for the application."
  type        = string
  default = null
}

variable "sla" {
  description = "Service Level Agreement (SLA) for the application."
  type        = string
  default = null
}

variable "description" {
  description = "A brief description of the application."
  type        = string
  default = null
}


#vm tags
variable "appname" {
  description = "The name of the application."
  type        = string
  default = null
}

variable "businessowner" {
  description = "The business owner responsible for the application."
  type        = string
  default = null
}

variable "businessunit" {
  description = "The business unit associated with the application."
  type        = string
  default = null
}

variable "costcenter" {
  description = "The cost center responsible for the application expenses."
  type        = string
  default = null
}



variable "projectname" {
  description = "The name of the project associated with the application."
  type        = string
  default = null
}

variable "requestedby" {
  description = "The person or entity that requested the application."
  type        = string
  default = null
}

