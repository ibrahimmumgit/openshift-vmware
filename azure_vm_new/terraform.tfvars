
applicationname = "rudsq"
applicationtype = "DB"
rg_prefix       = "ptazsg"
#resource_group_name                = "PTAZSG-IAC-DEV-VMC-RG"
create_new_resource_group = true
create_new_key_vault      = true
#key_vault_name                     = "ptazsg-5vmc-kv"


create_recovery_service = true

environment          = "DEV"
location             = "Central India"
create_backup        = true
create_backup_policy = true



# VM Configuration
vm_size = "Standard_DS1_v2"


#disk_encryption_name               = "ptazsg-5vm1-de" # If create key vault is false, use this variable

#DataDisk Count 
create_new_data_disk = false
data_disk_count      = 2
zone                 = 1

#Recovery Vault
#create_recovery_service = true
#recovery_vault_name = "value" 

# Identity and Access
identity_access            = true #"UserAssigned"
create_new_identity_access = false
#identity_name                      = "ptazsg-5vmc-msi"


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
