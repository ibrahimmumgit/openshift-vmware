# Key Vault
// resource "azurerm_key_vault" "vault" {
//   count                      = !var.data_encryption_type && var.create_new_key_vault ? 1 : 0
//   name                       = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-kv" : var.environment == "UAT" ? "-4${local.effective_applicationname}-kv" : "-5${local.effective_applicationname}-kv"}")
//   resource_group_name        = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
//   location                   = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
//   tenant_id                  = data.azurerm_client_config.current.tenant_id
//   sku_name                   = var.sku_name
//   purge_protection_enabled   = true
//   soft_delete_retention_days = var.soft_delete_retention_days
// }

// # Access Policy for Terraform User
// resource "azurerm_key_vault_access_policy" "terraform_user_policy" {
//   count              = !var.data_encryption_type && var.create_new_key_vault ? 1 : (var.key_vault_name != null && !local.object_id_exists_tf) ? 1 : 0
//   key_vault_id       = var.create_new_resource_group || var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
//   object_id          = data.azurerm_client_config.current.object_id
//   tenant_id          = data.azurerm_client_config.current.tenant_id
//   secret_permissions = ["Get"]
//   key_permissions    = [ "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", "GetRotationPolicy", "SetRotationPolicy" ]

//   depends_on = [azurerm_key_vault.vault]
// }

# Key Vault Key
// resource "azurerm_key_vault_key" "vault_key" {
//   count        = !var.data_encryption_type && var.create_new_key_key ? 1 : 0
//   name         = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-kvk" : var.environment == "UAT" ? "-4${local.effective_applicationname}-kvk" : "-5${local.effective_applicationname}-kvk"}")
//   key_vault_id = var.create_new_resource_group || var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
//   key_type     = "RSA"
//   key_size     = 2048
//   key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

//   depends_on = [azurerm_key_vault.vault,
//   azurerm_key_vault_access_policy.terraform_user_policy]
// }

# Access Policy for Storage Account
resource "azurerm_key_vault_access_policy" "storage_policy" {
   count        = !var.data_encryption_type ? 1 : 0
   key_vault_id = data.azurerm_key_vault.vault.id
   tenant_id    = data.azurerm_client_config.current.tenant_id
   object_id    = azurerm_storage_account.main.identity[0].principal_id
   key_permissions = [ "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", "GetRotationPolicy", "SetRotationPolicy"]

   depends_on = [ azurerm_storage_account.main]
}

# User Identity Access Policy
resource "azurerm_key_vault_access_policy" "user_identity_access" {
   count           = var.identity_access && var.create_new_identity_access ? 1 : 0
   key_vault_id    = data.azurerm_key_vault.vault.id
   tenant_id       = data.azurerm_client_config.current.tenant_id
   object_id       = !var.create_new_identity_access && var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].principal_id : azurerm_user_assigned_identity.uai[0].principal_id
   key_permissions = ["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy", "WrapKey", "UnwrapKey"]

}