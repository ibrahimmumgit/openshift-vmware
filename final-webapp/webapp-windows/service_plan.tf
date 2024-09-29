# Azure Service Plan for windows web Apps
resource "azurerm_service_plan" "aspwindows" {
  #count                  = var.windows_funcapp_count == 0 ? 0 : (var.windows_funcapp_count != 0 && local.ewindows_plan_len == 0) ? 1 : local.windows_serviceplan_names_from_file_length 
  count                  = var.create_new_service_plan ? 1 : 0
  name                   = (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}asp" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}asp" : "5${local.effective_applicationname}asp", local.existing_serviceplans_max_resource_numbers + 1))
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type                = "Windows"
  sku_name               = var.sku_size_windows
  zone_balancing_enabled = local.effective_environment == "PROD" && var.zone_redundant
  worker_count           = var.windows_instance_count
  # Ignore changes to the service plan name
  lifecycle {
    ignore_changes = [name]
  }
  tags = merge(local.common_tags, {
    "Type" = "webappwindows"
  })
}

