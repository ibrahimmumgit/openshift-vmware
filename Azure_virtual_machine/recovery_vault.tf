# Step 1: Create Recovery Services Vault
resource "azurerm_recovery_services_vault" "recovery_services" {
  count               = var.create_backup && var.create_recovery_service ? 1 : 0
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-rvs" : var.environment == "UAT" ? "-4${local.effective_applicationname}-rvs" : "-5${local.effective_applicationname}-rvs"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = var.recovery_vault_sku_name
  tags                = local.common_tags
  soft_delete_enabled = false
}

# Step 2: Retrieve an existing backup policy in the vault
data "azurerm_backup_policy_vm" "default_policy" {
  count               = !var.create_backup_policy && var.create_backup ? 1 : 0
  name                = "DefaultPolicy"
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  recovery_vault_name = var.create_recovery_service ? azurerm_recovery_services_vault.recovery_services[0].name : var.recovery_vault_name
}

# Step 2: Create Backup Policy
resource "azurerm_backup_policy_vm" "bkp_policy" {
  count                      = var.create_backup && var.create_backup_policy ? 1 : 0
  name                       = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-rsv-vmpolicy" : var.environment == "UAT" ? "-4${local.effective_applicationname}-rsv-vmpolicy" : "-5${local.effective_applicationname}-rsv-vmpolicy"}")
  resource_group_name        = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  recovery_vault_name        = var.create_recovery_service ? azurerm_recovery_services_vault.recovery_services[0].name : var.recovery_vault_name
  
  timezone = "Singapore Standard Time"

  backup {
    frequency = "Daily"
    time      = "18:00"
  }
 # Conditional Retention Policy for Non-PROD (Daily and Monthly Retention)
  retention_daily {
    count = local.environment == "PROD" ? 14 : 10
  }
  dynamic "retention_weekly" {
    for_each = local.environment == "PROD" ? [1] : []
    content {
      count = 4
      weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
    }
  }
  # retention_weekly {
  #   count    = local.environment == "PROD" ? 4 : 0  # Only apply for PROD
  #   weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  # }

  retention_monthly {
    count    = local.environment == "PROD" ? 12 : 3  # Only apply for PROD
    weekdays = ["Friday"]
    weeks    = ["Last"]
  }

  # # Only define yearly retention for PROD
  # retention_yearly {
  #   count    = local.environment == "PROD" ? 12 : null  # Set to null for non-PROD to remove the block
  #   weekdays = ["Sunday"]
  #   weeks    = ["Last"]
  #   months   = ["January"]
  # }

depends_on = [ azurerm_recovery_services_vault.recovery_services ]
  # For Non-PROD, there is no weekly or yearly retention, so you can omit or set to 0 if desired.
}

# Step 3: Register VM to Recovery Vault
resource "azurerm_backup_protected_vm" "protected_vm" {
  count               = var.create_backup ? 1 : 0
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  recovery_vault_name = var.create_recovery_service ? azurerm_recovery_services_vault.recovery_services[0].name : var.recovery_vault_name
  source_vm_id        = azurerm_windows_virtual_machine.main.id
  backup_policy_id    = azurerm_backup_policy_vm.bkp_policy[0].id
  lifecycle {
    prevent_destroy = false
  }
}

