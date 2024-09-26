# Azure Service Plan for Linux webtion Apps
resource "azurerm_service_plan" "asplinux" {
  count                  = var.linux_webapp_count == 0 ? 0 : (var.linux_webapp_count != 0 && local.elinux_plan_len == 0) ? 1 : local.linux_serviceplan_names_from_file_length
  name                   = lower(local.linux_app_service_plan_names[0])
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type                = "Linux"
  sku_name               = var.sku_size_linux
  zone_balancing_enabled = local.effective_environment == "PROD" && var.zone_redundant
  worker_count           = var.linux_instance_count
  tags = local.common_tags
}

# Azure Service Plan for Windows webtion Apps
resource "azurerm_service_plan" "aspwindows" {
  count                  = var.windows_webapp_count == 0 ? 0 : (var.windows_webapp_count != 0 && local.ewindows_plan_len == 0) ? 1 : local.windows_serviceplan_names_from_file_length
  name                   = lower(local.windows_app_service_plan_names[0])
  resource_group_name    = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type                = "Windows"
  sku_name               = var.sku_size_windows
  zone_balancing_enabled = local.effective_environment == "PROD" && var.zone_redundant
  worker_count           = var.windows_instance_count
  tags = local.common_tags
}
