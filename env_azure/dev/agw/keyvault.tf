data "azurerm_client_config" "current" {}

# create key vault
resource "azurerm_key_vault" "vault" {
  #name                       = "ptazsg-${var.environment == "PROD" ? "1iac-${var.projectname}-kv01" : var.environment == "UAT" ? "4iac-${var.projectname}-kv01" : "5iac-${var.projectname}-kv01"}"
  name                        = lower("ptazsg-${var.environment == "PROD" ? "1iac-${var.projectname}-kv01" : var.environment == "UAT" ? "4iac-${var.projectname}-kv01" : "5iac-${var.projectname}-kv01"}")
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "List",
      "Recover"
    ]
    
    }
}
# Generate a random password
resource "random_password" "secret" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "kvs" {
  name         = lower("ptazsg-${var.environment == "PROD" ? "iac-1${var.projectname}-password-v1" : var.environment == "UAT" ? "iac-4${var.projectname}-password-v1" : "iac-5${var.projectname}-password-v1"}")
  value        = random_password.secret.result
  key_vault_id = azurerm_key_vault.vault.id
}


data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = azurerm_key_vault_secret.kvs.name
  key_vault_id = azurerm_key_vault.vault.id
}