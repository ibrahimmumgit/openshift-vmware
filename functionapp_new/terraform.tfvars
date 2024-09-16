# Variable declarations for the Terraform configuration
applicationname           = "mhaweq"
location                  = "japaneast"
environment               = "DEV"
create_new_resource_group = true
rg_prefix                 = "ptazsg"
#resource_group_name  = ""

linux_funcapp_count     = 1
windows_funcapp_count   = 0
sku_size_linux          = "B2"
sku_size_windows        = "B1"
runtime_stack_linux     = "python"
runtime_version_linux   = "3.9"
runtime_stack_windows   = "dotnet"
runtime_version_windows = "v8.0"
linux_instance_count    = 1
windows_instance_count  = 1
zone_redundant          = false

create_storage_account   = true
storage_account_name     = ""
account_replication_type = "LRS"
account_kind             = "StorageV2"
account_tier             = "Standard"


enable_monitoring                        = true
create_new_application_insigts           = true
application_insights_name                = ""
application_insights_resource_group_name = ""
sku                                      = "PerGB2018"


role_access      = "petronasgroup"
custom_role_name = "Petronas Role Based Access control Administrator"

create_new_identity_access        = true
identity_access                   = "SystemAssigned, UserAssigned" # Set this to the name of the user-assigned identity if needed
identity_name                     = null                           # Set this to the name of the user-assigned identity if needed
identity_name_resource_group_name = ""



####Tags
project_code          = "03703"
applicationid         = "ALPHA"
costcenter            = "001PXXX12"
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
srnumber              = "REQ000006277983"


