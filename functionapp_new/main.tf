resource "azurerm_linux_function_app" "funcapp_linux" {
  count                         = var.linux_funcapp_count
  name                          = lower(local.linux_funcapp_names[count.index])
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id               = local.linux_app_service_plan_ids
  storage_account_name          = var.create_storage_account ? azurerm_storage_account.asa[0].name : data.azurerm_storage_account.asa[0].name
  storage_account_access_key    = var.create_storage_account ? azurerm_storage_account.asa[0].primary_access_key : data.azurerm_storage_account.asa[0].primary_access_key
  https_only                    = true
  enabled                       = true
  public_network_access_enabled = false
  identity {
    type         = var.identity_access == "SystemAssigned" ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access == "SystemAssigned" ? null : [var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].id : azurerm_user_assigned_identity.uai[0].id]
  }
  site_config {
    minimum_tls_version                    = "1.2"
    application_insights_connection_string = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].connection_string : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].connection_string : null)
    application_insights_key               = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].instrumentation_key : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].instrumentation_key : null)
    application_stack {
      java_version            = var.runtime_stack_linux == "java" ? var.runtime_version_linux : null
      dotnet_version          = var.runtime_stack_linux == "dotnet" ? var.runtime_version_linux : null
      node_version            = var.runtime_stack_linux == "node" ? var.runtime_version_linux : null
      python_version          = var.runtime_stack_linux == "python" ? var.runtime_version_linux : null
      powershell_core_version = var.runtime_stack_linux == "powershell" ? var.runtime_version_linux : null
    }

  }
  lifecycle {
    ignore_changes = [name]
  }
  tags = local.common_tags
}

#Create the windows function app if service plan os_type is windows
resource "azurerm_windows_function_app" "funcapp_windows" {
  count                         = var.windows_funcapp_count
  name                          = lower(local.windows_funcapp_names[count.index])
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id               = local.windows_app_service_plan_ids
  storage_account_name          = var.create_storage_account ? azurerm_storage_account.asa[0].name : data.azurerm_storage_account.asa[0].name
  storage_account_access_key    = var.create_storage_account ? azurerm_storage_account.asa[0].primary_access_key : data.azurerm_storage_account.asa[0].primary_access_key
  https_only                    = true
  enabled                       = true
  public_network_access_enabled = false
  identity {
    type         = var.identity_access == "SystemAssigned" ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access == "SystemAssigned" ? null : [var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].id : azurerm_user_assigned_identity.uai[0].id]
  }
  site_config {
    minimum_tls_version                    = "1.2"
    application_insights_connection_string = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].connection_string : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].connection_string : null)
    application_insights_key               = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].instrumentation_key : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].instrumentation_key : null)
    application_stack {
      java_version   = var.runtime_stack_windows == "java" ? var.runtime_version_windows : null
      dotnet_version = var.runtime_stack_windows == "dotnet" ? var.runtime_version_windows : null
      node_version   = var.runtime_stack_windows == "node" ? var.runtime_version_windows : null
      #python_version          = var.runtime_stack_windows == "python" ? var.runtime_version_windows : null
      powershell_core_version = var.runtime_stack_windows == "powershell" ? var.runtime_version_windows : null
    }
  }
  lifecycle {
    ignore_changes = [name]
  }
  tags = local.common_tags
}