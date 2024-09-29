resource "azurerm_windows_web_app" "webapp_windows" {
  count                         = var.windows_webapp_count
  name                          = lower(local.windows_webapp_names[count.index])
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id               = var.create_new_service_plan ? azurerm_service_plan.aspwindows[0].id : data.azurerm_service_plan.details[0].id
https_only                    = true
  enabled                       = true
  public_network_access_enabled = false
  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      java_version            = var.runtime_stack_windows == "java" ? var.runtime_version_windows : null
      dotnet_version          = var.runtime_stack_windows == "dotnet" ? var.runtime_version_windows : null
      node_version            = var.runtime_stack_windows == "node" ? var.runtime_version_windows : null
      
    }

  }
  lifecycle {
    ignore_changes = [name]
  }
  tags = local.common_tags
}
