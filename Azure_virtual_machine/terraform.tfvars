applicationname                    = "vme"
applicationtype = "APP"
rg_prefix                          = "ptazsg"
resource_group_name                = "PTAZSG-IAC-DEV-VMC-RG"
create_new_resource_group          = true
create_new_key_vault               = true
#key_vault_name                     = "ptazsg-5vmc-kv"
create_new_key                     = true
#key_name = "ptazsg-5vmc-kvk"
create_recovery_service            = true
#recovery_vault_name                = ""
environment                        = "UAT"
location                           = "Central US"
create_backup                       = true
create_backup_policy                       = true
# Windows Image Information
vm_image_publisher                 = "MicrosoftWindowsServer"
vm_image_offer                     = "WindowsServer"
vm_image_sku                       = "2016-Datacenter"
vm_image_version                   = "latest"

# VM Configuration
vm_size                            = "Standard_DS1_v2"
vm_vnet_network_name                = "vm-vnet - default"
resource_group_name_vm_vnet  = "RG-AKS-AzSHCI"
# Disk Encryption
create_disk_encryption = true
#disk_encryption_name               = "ptazsg-5vm1-de" # If create key vault is false, use this variable

#DataDisk Count 
create_new_data_disk = true
data_disk_count = 0
zone = 1

#Recovery Vault
#create_recovery_service = true
#recovery_vault_name = "value" 

# Identity and Access
identity_access                    = true #"UserAssigned"
create_new_identity_access         = false
#identity_name                      = "ptazsg-5vmc-msi"

role_access      = "petronasgroup"
custom_role_name = "Petronas Role Based Access control Administrator"

####Tags
project_code          = "03703"
applicationid         = "AH"
costcenter            = "00"
dataclassification    = "Confidential"
scaclassification     = "Standard"
productowner          = "user@petronas.com"
productsupport        = "user@petronas.com"
businessowner         = "user@petronas.com"
csbia_availability    = "Moderate"
csbia_confidentiality = "Major"
csbia_impactscore     = "Major"
csbia_integrity       = "Moderate"
businessopu_hcu       = "GTS"
businessstream        = "PDnT"