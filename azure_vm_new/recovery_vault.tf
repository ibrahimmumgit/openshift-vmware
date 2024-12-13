# Step 1: Create Recovery Services Vault
resource "azurerm_recovery_services_vault" "recovery_services" {
  count               = var.create_backup && var.create_recovery_service ? 1 : 0
  name                = upper("${var.rg_prefix}-IAC-${local.effective_environment}-${local.effective_applicationname}-RSV")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = var.recovery_vault_sku_name
  tags                = local.common_tags
  soft_delete_enabled = false
}




# Register VM to Recovery Vault
resource "azurerm_backup_protected_vm" "protected_vm" {
  count               = var.create_backup ? 1 : 0
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  recovery_vault_name = var.create_recovery_service ? azurerm_recovery_services_vault.recovery_services[0].name : upper("${var.rg_prefix}-IAC-${local.effective_environment}-${local.effective_applicationname}-RSV")
  source_vm_id        = azurerm_windows_virtual_machine.main.id
  backup_policy_id    = var.create_backup && var.create_backup_policy ? azurerm_backup_policy_vm.bkp_policy[0].id : data.azurerm_backup_policy_vm.bkp_policy[0].id
  lifecycle {
    prevent_destroy = false
  }
}

