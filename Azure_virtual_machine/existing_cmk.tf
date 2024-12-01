data "azurerm_key_vault" "cmk_vault" {

  resource_group_name = local.effective_environment == "PROD" ? "PTAZSG-IAC-PROD-CMK-RG" : local.effective_environment == "UAT" ? "PTAZSG-IAC-UAT-STGONE-RG" : "PTAZSG-IAC-DEV-CMK-RG"
  name                = local.effective_environment == "PROD" ? "PTAZSG-1CMK-KV" : local.effective_environment == "UAT" ? "ptazsg-4stgone-kv-01" : "PTAZSG-5CMK-KV"  #var.key_vault_name # Specify the name of your existing Key Vault
}

# Data source for the key in the Key Vault
data "azurerm_key_vault_key" "cmk_vault_key" {

  name         = local.effective_environment == "PROD" ? "PTAZSG-IAC-PROD-VmDiskEncryption-RSA-KEK-CMK" : local.effective_environment == "UAT" ? "ptazsg-4stgone-kvk-01"  : "PTAZSG-IAC-DEV-VmDiskEncryption-RSA-KEK-CMK" # Specify the name of the key you want to retrieve
  key_vault_id = data.azurerm_key_vault.cmk_vault.id
}