# --- Variable Declarations for Terraform Configuration ---

# --- Variable Declarations for Terraform Configuration ---

# The name of the application or project where the Azure FunctionApp Service will be deployed.
variable "applicationname" {
  description = <<EOT
Name of the Project where the Azure Windows VM will be deployed. 
**Changing this value will recreate the resource.**
EOT
  type        = string
  default     = null
}

# The type of application where the Azure Windows VM will be deployed.
variable "applicationtype" {
  description = <<EOT
Type of the application where the Azure Windows VM will be deployed.
**Changing this value may recreate the resource.**
EOT
  type        = string
  default     = null
}

# The location where the resource group will be created in Azure.
variable "location" {
  description = <<EOT
Resource group location. 
**Changing this value will recreate the resource.**
EOT
  type        = string
  default     = null
}

# The environment type for the resources.
variable "environment" {
  description = <<EOT
The Environment type (e.g., DEV, UAT, PROD). 
**Changing this value may recreate the resource.**
EOT
  type        = string
  default     = null
}

# The name of an existing resource group in which resources will be deployed.
variable "resource_group_name" {
  description = <<EOT
Name of the existing resource group. 
**Changing this value will not recreate the resource but will use a different resource group.**
EOT
  type        = string
  default     = null
}

# Flag to specify whether to create a new resource group (true) or use an existing one (false).
variable "create_new_resource_group" {
  description = <<EOT
Flag to indicate whether to create a new resource group. 
**Changing this value will recreate the resource group.**
EOT
  type        = bool
  default     = false
}

# The email or name of an Azure AD user or group to assign a role to in Azure.
variable "role_access" {
  description = "The email of the Azure AD user or the name of the Azure AD group to assign the role to."
  type        = string
  default     = null
}

# The custom role name that should be assigned in Azure.
variable "custom_role_name" {
  description = "Custom Role name to be created or assigned."
  type        = string
  default     = null
}

variable "source_imagename" {
  description = "Existing Image name"
  type        = string
  default = "PTAZSG-3COC-WS2022-V2"
}





# The size (SKU) of the Virtual Machine to be created (e.g., 'Standard_DS2_v2').
variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
  default     = "Standard_F2"
}

# The ID of the custom image to use for creating the Virtual Machine (VM).
# variable "vm_image_id" {
#   description = "The ID of the Image from which this Virtual Machine should be created. This variable supersedes the `vm_image` variable if not null."
#   type        = string
#   default     = null
# }


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



# Specifies the storage account type for the OS disk. Valid options are `Standard_LRS`, `Premium_LRS`, etc.

# Specifies the caching policy for the OS disk. Can be `ReadWrite`, `None`, or `ReadOnly`.
variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

# The name of the disk encryption type to use for the OS disk.
variable "create_disk_encryption" {
  description = "Set to true for disk encryption."
  type        = bool
  default     = false
}

variable "disk_encryption_name" {
  description = "Name of the disk encryption type."
  type        = string
  default     = null
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

variable "zone" {
  description = "Specifies the zone to be created."
  type        = number
  default     = 1
}


# Specifies the storage account type for the OS disk. Valid options are `Standard_LRS`, `Premium_LRS`, etc.


# Specifies the size of each data disk in gigabytes (GB).
variable "data_disk_size" {
  description = "Specifies the Data Disk size to be created."
  type        = number
  default     = 128
}

# Specifies to create new backup policy
variable "create_backup" {
  description = "Specifies whether to create a backup or not."
  type        = bool
  default     = false
}

variable "create_backup_policy" {
  description = "Specifies whether to create a new backup policy or not."
  type        = bool
  default     = false
}

# Flag to indicate whether to create a Recovery Service Vault or not.
variable "create_recovery_service" {
  description = "Specifies whether to create a recovery service vault or not."
  type        = bool
  default     = false
}

# The SKU for the Recovery Service Vault (e.g., `Standard`, `RS1`).
variable "recovery_vault_sku_name" {
  type        = string
  description = "Specifies the SKU name for the Recovery Service Vault."
  default     = "Standard"
}

# The name of the Recovery Service Vault.
variable "recovery_vault_name" {
  type        = string
  description = "Specifies the Name for the Recovery Service Vault."
  default     = null
}

# --- Network Configuration Variables ---

# The name of the virtual network (VNet) to which the VM should be connected.
# Networking Variables

// variable "vm_vnet_network_name" {
//   description = "The name of the Virtual Network to associate with the AKS cluster for private networking."
//   type        = string
//   default     = null
// }

// variable "resource_group_name_vm_vnet" {
//   description = "The name of the resource group where the AKS VNet is located."
//   type        = string
//   default     = null
// }

variable "host_offset_in_subnet" {
  description = "The offset (host number) within the subnet's CIDR block to calculate a specific IP address. This is an integer value that represents which host address you want to allocate. For example, if the subnet CIDR is '10.0.0.0/24' and you want to allocate '10.0.0.5', set 'host_offset_in_subnet' to 5."
  type        = number
}


# Flag to create a new Key Vault or use an existing one.
variable "create_new_key_vault" {
  description = "Set to true to create a new Key Vault, false to use an existing Key Vault."
  type        = bool
  default     = false
}

# The name of the existing Key Vault.
variable "key_vault_name" {
  description = "The name of the existing Key Vault to be used."
  type        = string
  default     = null
}

# Specifies the SKU for the Key Vault (e.g., 'standard' or 'premium').
variable "sku_name" {
  description = "Specifies the SKU name for the Key Vault."
  type        = string
  default     = "standard"
}

# Flag to create a new Key in the Key Vault or use an existing one.
variable "create_new_key" {
  description = "Set to true to create a new Key in the Key Vault, false to use an existing Key."
  type        = bool
  default     = false
}

# The name of the key in the Key Vault.
variable "key_name" {
  description = "The name of the existing key in the Key Vault."
  type        = string
  default     = null
}

# Specifies the number of days to retain soft deleted Key Vault items.
variable "soft_delete_retention_days" {
  description = "The number of days for which the Key Vault's soft delete feature retains deleted items."
  type        = number
  default     = 7
}

# --- Identity Configuration Variables ---

# Flag to indicate whether to create a new identity access.
variable "create_new_identity_access" {
  description = "Flag to indicate whether to create a new user identity."
  type        = bool
  default     = false
}


variable "identity_access" {
  description = "Flag to indicate of identity accesstype of identity Systemassigned(true) userassigned(false)."
  type        = bool
  default     = false
}

# The name of the user-assigned identity to use, if applicable.
variable "identity_name" {
  description = "Name of the user-assigned identity."
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

variable "project_code" {
  description = "The project code for resource classification."
  type        = string
  default     = null
}

variable "applicationid" {
  description = "The application ID for resource classification."
  type        = string
  default     = null
}

variable "costcenter" {
  description = "The cost center associated with the resources."
  type        = string
  default     = null
}

variable "dataclassification" {
  description = "The data classification for the resources."
  type        = string
  default     = null
}

variable "scaclassification" {
  description = "The SCA classification for the resources."
  type        = string
  default     = null
}

variable "iacrepo" {
  description = "The Infrastructure-as-Code repository associated with the resources."
  type        = string
  default     = null
}

variable "productowner" {
  description = "The owner of the product associated with the resources."
  type        = string
  default     = null
}

variable "productsupport" {
  description = "The support team for the product."
  type        = string
  default     = null
}

variable "businessowner" {
  description = "The business owner associated with the resources."
  type        = string
  default     = null
}

variable "csbia_availability" {
  description = "CSBIA Availability classification."
  type        = string
  default     = null
}

variable "csbia_confidentiality" {
  description = "CSBIA Confidentiality classification."
  type        = string
  default     = null
}

variable "csbia_impactscore" {
  description = "CSBIA Impact Score."
  type        = string
  default     = null
}

variable "csbia_integrity" {
  description = "CSBIA Integrity classification."
  type        = string
  default     = null
}

variable "businessopu_hcu" {
  description = "Business OPU/HCU classification."
  type        = string
  default     = null
}

variable "businessstream" {
  description = "The business stream associated with the resources."
  type        = string
  default     = null
}

