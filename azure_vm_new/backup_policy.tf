resource "azurerm_backup_policy_vm" "bkp_policy" {
  count = var.create_backup && var.create_backup_policy ? 1 : 0
  #name                           = upper("${var.rg_prefix}-IAC-${local.effective_environment}-${local.effective_applicationname}-RSV-VMPOLICY")
  name = upper(
    format(
      "%s-IAC-%s-%s-RSV-%s",
      var.rg_prefix,
      local.effective_environment,
      local.effective_applicationname,
      local.effective_application_type[local.apptype] != "db" ? "VMPOLICY" : "SQL"
    )
  )
  resource_group_name            = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  recovery_vault_name            = upper("${var.rg_prefix}-IAC-${local.effective_environment}-${local.effective_applicationname}-RSV")
  instant_restore_retention_days = 1
  timezone                       = "Singapore Standard Time"

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
      count    = 4
      weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
    }
  }
  # retention_weekly {
  #   count    = local.environment == "PROD" ? 4 : 0  # Only apply for PROD
  #   weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  # }

  retention_monthly {
    count    = local.environment == "PROD" ? 12 : 3 # Only apply for PROD
    weekdays = ["Friday"]
    weeks    = ["Last"]
  }

  # # Only define yearly retention for PROD

  dynamic "retention_yearly" {
    for_each = local.environment == "PROD" ? [1] : []
    content {
      count    = 12 # Set to null for non-PROD to remove the block
      weekdays = ["Sunday"]
      weeks    = ["Last"]
      months   = ["January"]
    }
  }


  depends_on = [azurerm_recovery_services_vault.recovery_services]
  # For Non-PROD, there is no weekly or yearly retention, so you can omit or set to 0 if desired.
}



data "azurerm_backup_policy_vm" "bkp_policy" {
  count = !var.create_backup_policy && var.create_backup ? 1 : 0
  name = upper(
    format(
      "%s-IAC-%s-%s-RSV-%s",
      var.rg_prefix,
      local.effective_environment,
      local.effective_applicationname,
      local.effective_application_type[local.apptype] != "db" ? "VMPOLICY" : "SQL"
    )
  )
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  recovery_vault_name = upper("${var.rg_prefix}-IAC-${local.effective_environment}-${local.effective_applicationname}-RSV")
}


