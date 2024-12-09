resource "azurerm_linux_web_app" "webapp_linux" {
  count               = var.linux_webapp_count
  name                = lower(local.linux_webapp_names[count.index])
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id     = local.linux_app_service_plan_ids
  https_only          = true
  enabled             = true
  identity {
    type         = var.identity_access == "SystemAssigned" ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access == "SystemAssigned" ? null : [var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].id : azurerm_user_assigned_identity.uai[0].id]
  }
  site_config {
    minimum_tls_version = "1.2"
    application_stack {

      dotnet_version = var.runtime_stack_linux == "dotnet" ? var.runtime_version_linux : null
      node_version   = var.runtime_stack_linux == "node" ? var.runtime_version_linux : null
      python_version = var.runtime_stack_linux == "python" ? var.runtime_version_linux : null
      java_version   = var.runtime_stack_linux == "java" ? var.runtime_version_linux  : null
      java_server         = var.runtime_stack_linux == "java" ? "TOMCAT" : null
      java_server_version = var.runtime_stack_linux == "java" ? "10.1" : null
      php_version         = var.runtime_stack_linux == "php" ? var.runtime_version_linux : null
      ruby_version        = var.runtime_stack_linux == "ruby" ? var.runtime_version_linux : null
    }
  }
  dynamic "backup" {
    for_each = var.backup_enable ? [1] : []
    content {
      name                = lower(local.linux_webapp_backup_names[count.index])
      storage_account_url = var.backup_enable && (var.create_new_resource_group || local.estorage_len == 0) ? "${azurerm_storage_account.asa[0].primary_blob_endpoint}${azurerm_storage_container.asc[0].name}?${data.azurerm_storage_account_sas.asas.sas}"  :"${data.azurerm_storage_account.asa[0].primary_blob_endpoint}${data.azurerm_storage_container.asc[0].name}?${data.azurerm_storage_account_sas.asas.sas}" 
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
    ignore_changes = [backup[0].storage_account_url]
  }
  tags = local.common_tags
}

#Create the windows webtion app if service plan os_type is windows
resource "azurerm_windows_web_app" "webapp_windows" {
  count               = var.windows_webapp_count
  name                = lower(local.windows_webapp_names[count.index])
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id     = local.windows_app_service_plan_ids
  https_only = true
  enabled    = true
  identity {
    type         = var.identity_access == "SystemAssigned" ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access == "SystemAssigned" ? null : [var.identity_name != null ? data.azurerm_user_assigned_identity.uai[0].id : azurerm_user_assigned_identity.uai[0].id]
  }
  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      current_stack =  var.runtime_stack_windows
      java_version   = var.runtime_stack_windows == "java" ? var.runtime_version_windows : null
      dotnet_version = var.runtime_stack_windows == "dotnet" ? var.runtime_version_windows : null
      node_version   = var.runtime_stack_windows == "node" ? var.runtime_version_windows : null   
    }
  }
  dynamic "backup" {
    for_each = var.backup_enable ? [1] : []
    content {
      name                = lower(local.windows_webapp_backup_names[count.index])
      storage_account_url = var.backup_enable && (var.create_new_resource_group || local.estorage_len == 0)? "${azurerm_storage_account.asa[0].primary_blob_endpoint}${azurerm_storage_container.asc[0].name}?${data.azurerm_storage_account_sas.asas.sas}"  :"${data.azurerm_storage_account.asa[0].primary_blob_endpoint}${data.azurerm_storage_container.asc[0].name}?${data.azurerm_storage_account_sas.asas.sas}" 
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
    ignore_changes = [backup[0].storage_account_url]
  }
  tags = local.common_tags
}