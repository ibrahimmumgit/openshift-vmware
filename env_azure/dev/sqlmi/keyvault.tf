# Create Key Vault
resource "azurerm_key_vault" "vault" {
  count                      = var.create_new_key_vault ? 1 : 0
  name                       = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-kv" : var.environment == "UAT" ? "-4${local.effective_applicationname}-kv" : "-5${local.effective_applicationname}-kv"}")
  resource_group_name        = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                   = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name_kv
  purge_protection_enabled   = true
  soft_delete_retention_days = var.soft_delete_retention_days
 
  access_policy {
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    key_permissions    = ["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy"]
    secret_permissions = ["Set", "Get", "List", "Delete", "Recover"]
  }
  
  lifecycle { ignore_changes = [access_policy] }
}
 
# Generate a random password
resource "random_password" "secret" {
  length  = 32
  special = true
}
 
# Key Vault Key
// resource "azurerm_key_vault_key" "key" {
//   count        = !var.use_custom_key && var.create_new_key ? 1 : 0
//   name         = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-kvk" : var.environment == "UAT" ? "-4${local.effective_applicationname}-kvk" : "-5${local.effective_applicationname}-kvk"}")
//   key_vault_id = azurerm_key_vault.vault[0].id
//   key_type     = "RSA"
//   key_size     = 2048
//   key_opts = [
//     "decrypt",
//     "encrypt",
//     "sign",
//     "unwrapKey",
//     "verify",
//     "wrapKey",
//   ]
 
//   depends_on = [
//     azurerm_key_vault.vault
//   ]
// }
 
# Key Vault Secret
resource "azurerm_key_vault_secret" "kvs" {
  name         = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-sql${local.next_sql_mi_name}-kvs" : var.environment == "UAT" ? "-4${local.effective_applicationname}-sql${local.next_sql_mi_name}-kvs" : "-5${local.effective_applicationname}-sql${local.next_sql_mi_name}-kvs"}")
  value        = random_password.secret.result
  key_vault_id = var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
 
  depends_on = [
    azurerm_key_vault.vault,
    random_password.secret
  ]
}
data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = azurerm_key_vault_secret.kvs.name
  key_vault_id = var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
}
  
# Managed Instance Access Policy
resource "azurerm_key_vault_access_policy" "mi_policy" {
  count        = !var.use_custom_key && var.identity_access  ? 1 : 0
  key_vault_id = data.azurerm_key_vault.cmk_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_mssql_managed_instance.main.identity[0].principal_id
  #object_id = var.identity_access ? azurerm_mssql_managed_instance.main.identity[0].principal_id : !var.create_new_identity_access && var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].principal_id : azurerm_user_assigned_identity.uai[0].principal_id
  key_permissions = ["Get", "WrapKey", "UnwrapKey"]

  depends_on = [
    azurerm_mssql_managed_instance.main
  ]
}

# User Identity Access Policy
resource "azurerm_key_vault_access_policy" "user_identity_access" {
  count           = !var.identity_access && var.create_new_identity_access ? 1 : 0
  key_vault_id    = data.azurerm_key_vault.cmk_vault.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = !var.create_new_identity_access && var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].principal_id : azurerm_user_assigned_identity.uai[0].principal_id
  key_permissions = ["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy", "WrapKey", "UnwrapKey"]

  depends_on = [
    azurerm_key_vault.vault,
    azurerm_user_assigned_identity.uai
  ]
}