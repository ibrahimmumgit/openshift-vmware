# Create a Disk Encryption Set
resource "azurerm_disk_encryption_set" "disk_encryption" {
  count               = var.create_disk_encryption ? 1 : 0
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-de" : var.environment == "UAT" ? "-4${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-de" : "-5${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-de"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  key_vault_key_id    = data.azurerm_key_vault_key.cmk_vault_key.id
  tags                = local.common_tags
  identity {
    type         = var.identity_access ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access ? null : [var.create_new_identity_access && var.identity_name == null ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id]
  }
  depends_on = [
    azurerm_key_vault_access_policy.user_identity_access, # Ensure UAI has access before encryption set is created
   # azurerm_key_vault_access_policy.disk_encryption_access_policy
  ]
}
 
data "azurerm_disk_encryption_set" "disk_encryption" {
  count               = var.create_disk_encryption ? 0 : 1
  name                = var.disk_encryption_name # The name of the encryption set
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}