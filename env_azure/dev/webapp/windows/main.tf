resource "azurerm_windows_web_app" "webapp_windows" {
  count                         = var.windows_webapp_count
  name                          = lower(local.windows_webapp_names[count.index])
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
#location = var.location 
service_plan_id               = var.create_new_service_plan ? azurerm_service_plan.aspwindows[0].id : data.azurerm_service_plan.details[0].id
https_only                    = true
  enabled                       = true
  public_network_access_enabled = false
    identity {
    type         = var.identity_access == "SystemAssigned" ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access == "SystemAssigned" ? null : [var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].id : azurerm_user_assigned_identity.uai[0].id]
  }
  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      current_stack           = var.runtime_stack_windows 
      dotnet_version          = var.runtime_stack_windows == "dotnet" ? var.runtime_version_windows : null
      node_version            = var.runtime_stack_windows == "node" ? var.runtime_version_windows : null
      dotnet_core_version     = var.runtime_stack_windows == "dotnetcore" ? var.runtime_version_windows : null
      
    }

  }

  dynamic "backup" {
    for_each = var.backup_enable ? [1] : []
    content {
      name                = lower(local.windows_webapp_backup_names[count.index])
      storage_account_url = var.create_storage_account ? "${azurerm_storage_account.asa[0].primary_blob_endpoint}${(var.create_storage_account || var.create_container ? azurerm_storage_container.asc[0].name : data.azurerm_storage_container.asc[0].name)}?${data.azurerm_storage_account_sas.asas[0].sas}" : "${data.azurerm_storage_account.asa[0].primary_blob_endpoint}${(var.create_storage_account || var.create_container  ? azurerm_storage_container.asc[0].name : data.azurerm_storage_container.asc[0].name)}?${data.azurerm_storage_account_sas.asas[0].sas}"
      #storage_account_url = var.backup_enable && var.create_storage_account ? "${azurerm_storage_account.asa[0].primary_blob_endpoint}${azurerm_storage_container.asc[0].name}?${data.azurerm_storage_account_sas.asas.sas}"  :"${data.azurerm_storage_account.asa[0].primary_blob_endpoint}${data.azurerm_storage_container.asc[0].name}?${data.azurerm_storage_account_sas.asas.sas}" 
      schedule {
        frequency_interval = var.frequency_interval
        frequency_unit     = "Day"
        retention_period_days = 30       
        keep_at_least_one_backup = true 
      }
    }
  }
  # Add Application Insights monitoring
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].instrumentation_key : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].instrumentation_key : null)
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.enable_monitoring && length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].connection_string : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].connection_string : null)
  }


  lifecycle {
    ignore_changes = [name]
  }
  tags = local.common_tags
}