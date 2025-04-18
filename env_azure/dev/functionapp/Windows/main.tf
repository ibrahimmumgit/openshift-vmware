resource "azurerm_windows_function_app" "funcapp_windows" {
  count                         = var.windows_funcapp_count
  name                          = lower(local.truncated_windows_funcapp_names[count.index])
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  #location = var.location
  service_plan_id               = var.create_new_service_plan ? azurerm_service_plan.aspwindows[0].id : data.azurerm_service_plan.details[0].id
  storage_account_name          = var.create_storage_account ? azurerm_storage_account.asa[0].name : data.azurerm_storage_account.asa[0].name
  storage_account_access_key    = var.create_storage_account ? azurerm_storage_account.asa[0].primary_access_key : data.azurerm_storage_account.asa[0].primary_access_key
  https_only                    = true
  enabled                       = true
  #public_network_access_enabled = false
  identity {
    type         = var.identity_access == "SystemAssigned" ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access == "SystemAssigned" ? null : [var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].id : azurerm_user_assigned_identity.uai[0].id]
  }
  site_config {
    minimum_tls_version                    = "1.2"
    application_insights_connection_string = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].connection_string : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].connection_string : null)
    application_insights_key               = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].instrumentation_key : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].instrumentation_key : null)
    application_stack {
      java_version            = var.runtime_stack_windows == "java" ? var.runtime_version_windows : null
      dotnet_version          = var.runtime_stack_windows == "dotnet" ? var.runtime_version_windows : null
      node_version            = var.runtime_stack_windows == "node" ? var.runtime_version_windows : null
      powershell_core_version = var.runtime_stack_windows == "powershell" ? var.runtime_version_windows : null
    }

  }
  vnet_image_pull_enabled = contains(local.sku_isolated_size, local.service_plan_size) ? false : true
  lifecycle {
    ignore_changes = [name]
  }
  tags = local.common_tags
}
