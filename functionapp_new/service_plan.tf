# Azure Service Plan for Linux Function Apps
resource "azurerm_service_plan" "asplinux" {
  count                  = var.linux_funcapp_count == 0 ? 0 : (var.linux_funcapp_count != 0 && local.elinux_plan_len == 0) ? 1 : local.linux_serviceplan_names_from_file_length
  name                   = lower(local.linux_app_service_plan_names[0])
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type                = "Linux"
  sku_name               = var.sku_size_linux
  zone_balancing_enabled = local.effective_environment == "PROD" && var.zone_redundant
  worker_count           = var.linux_instance_count
  app_service_environment_id = var.sku_size_linux == null ? null : contains(local.sku_isolated_size, var.sku_size_linux) ? null : (local.effective_environment == "PROD" && var.zone_redundant == "true" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE04-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    local.effective_environment == "PROD" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE03-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    local.effective_environment == "UAT" ? "/subscriptions/1c334150-08b8-4088-9170-074fa26a9926/resourceGroups/PTAZSG-IAC-UAT-ASE01-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-4iacase01" :
    "/subscriptions/2be5068f-e0ac-4d57-aedc-96bc9798a265/resourceGroups/PTAZSG-IAC-DEV-ASE02-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-5ase02"
  )
  tags = local.common_tags
}

# Azure Service Plan for Windows Function Apps
resource "azurerm_service_plan" "aspwindows" {
  count                  = var.windows_funcapp_count == 0 ? 0 : (var.windows_funcapp_count != 0 && local.ewindows_plan_len == 0) ? 1 : local.windows_serviceplan_names_from_file_length
  name                   = lower(local.windows_app_service_plan_names[0])
  resource_group_name    = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type                = "Windows"
  sku_name               = var.sku_size_windows
  zone_balancing_enabled = local.effective_environment == "PROD" && var.zone_redundant
  worker_count           = var.windows_instance_count
  app_service_environment_id = var.sku_size_windows == null ? null : contains(local.sku_isolated_size, var.sku_size_windows) ? null : (local.effective_environment == "PROD" && var.zone_redundant == "true" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE04-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    local.effective_environment == "PROD" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE03-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    local.effective_environment == "UAT" ? "/subscriptions/1c334150-08b8-4088-9170-074fa26a9926/resourceGroups/PTAZSG-IAC-UAT-ASE01-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-4iacase01" :
    "/subscriptions/2be5068f-e0ac-4d57-aedc-96bc9798a265/resourceGroups/PTAZSG-IAC-DEV-ASE02-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-5ase02"
  )
  tags = local.common_tags
}


