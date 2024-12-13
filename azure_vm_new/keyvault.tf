# create key vault
resource "azurerm_key_vault" "vault" {
  count                       = var.create_new_key_vault ? 1 : 0
  name                        = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-kv" : var.environment == "UAT" ? "-4${local.effective_applicationname}-kv" : "-5${local.effective_applicationname}-kv"}")
  resource_group_name         = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                    = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  purge_protection_enabled    = true
  soft_delete_retention_days  = var.soft_delete_retention_days
  enabled_for_disk_encryption = true
  tags                        = local.common_tags
}
# Step 2: Add Access Policy for Terraform User
resource "azurerm_key_vault_access_policy" "terraform_user_policy" {
  count                   = var.create_new_key_vault ? 1 : (var.key_vault_name != null && !local.object_id_exists_tf) ? 1 : 0
  key_vault_id            = var.create_new_resource_group || var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
  object_id               = data.azurerm_client_config.current.object_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]

  # Ensure it depends on the Key Vault being created
  depends_on = [azurerm_key_vault.vault]
}

resource "random_password" "secret" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "kvs" {
  name         = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-kvs" : var.environment == "UAT" ? "-4${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-kvs" : "-5${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-kvs"}")
  value        = random_password.secret.result
  key_vault_id = var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
  depends_on   = [azurerm_key_vault.vault, azurerm_key_vault_access_policy.terraform_user_policy]
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = azurerm_key_vault_secret.kvs.name
  key_vault_id = var.create_new_resource_group || var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
}

data "azurerm_key_vault" "vault" {
  count               = (!var.create_new_resource_group && !var.create_new_key_vault && var.key_vault_name != null) ? 1 : 0
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  name                = var.key_vault_name
}

resource "azurerm_key_vault_access_policy" "vm_policy" {
  key_vault_id = var.create_new_resource_group || var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_windows_virtual_machine.main.identity[0].principal_id

  key_permissions = ["Get", "WrapKey", "UnwrapKey"]

  depends_on = [
    azurerm_key_vault.vault,
    azurerm_windows_virtual_machine.main
  ]
}

# Add access policy for user-assigned identity to access keys and secrets in Key Vault
resource "azurerm_key_vault_access_policy" "user_identity_access" {
  count                   = var.create_new_identity_access && !local.user_identity_id_exists ? 1 : 0
  key_vault_id            = var.create_new_resource_group || var.create_new_key_vault ? azurerm_key_vault.vault[0].id : data.azurerm_key_vault.vault[0].id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = !var.create_new_identity_access && var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].principal_id : azurerm_user_assigned_identity.uai[0].principal_id
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]

  depends_on = [
    azurerm_key_vault.vault,
    azurerm_key_vault_access_policy.terraform_user_policy
  ]
}