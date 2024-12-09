
applicationname     = "stgone"



create_new_key_vault                       = true
create_new_key_key                         = true
public_network_access_enabled              = false
public_network_access_enabled_network_name = ""
allow_access_from                          = true
resource_group_name_public_access          = "test"
resource_group_name_private_endpoint       = ""

default_action = ""

environment = "UAT"
location    = "Central US"


data_encryption_type       = false
identity_access            = false
create_new_identity_access = false



role_access      = "petronasgroup"
custom_role_name = "Petronas Role Based Access control Administrator"

project_code          = "03703"
applicationid         = "AH"
costcenter            = "00"
dataclassification    = "Confidential"
scaclassification     = "Standard"
productowner          = "user@test.com"
productsupport        = "user@test.com"
businessowner         = "user@test.com"
csbia_availability    = "Moderate"
csbia_confidentiality = "Major"
csbia_impactscore     = "Major"
csbia_integrity       = "Moderate"
businessopu_hcu       = "GTS"
businessstream        = "PDnT"
