resource "azurerm_linux_web_app" "webapp_linux" {
  count                         = var.linux_webapp_count
  name                          = lower(local.linux_webapp_names[count.index])
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id               = var.create_new_service_plan ? azurerm_service_plan.asplinux[0].id : data.azurerm_service_plan.details[0].id
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
      java_version            = var.runtime_stack_linux == "java" ? var.runtime_version_linux : null
      dotnet_version          = var.runtime_stack_linux == "dotnet" ? var.runtime_version_linux : null
      node_version            = var.runtime_stack_linux == "node" ? var.runtime_version_linux : null
      python_version          = var.runtime_stack_linux == "python" ? var.runtime_version_linux : null
     
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
