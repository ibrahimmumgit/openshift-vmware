#define the sku size which is required the app_service_environment_id
locals {
  sku_isolated_size = ["B1", "B2", "B3", "S1", "S2", "S3"]
}

# Azure Service Plan for Linux Function Apps
resource "azurerm_service_plan" "asplinux" {
  count                  = var.linux_funcapp_count == 0 ? 0 : (var.app_service_plan == "separate" ? var.linux_funcapp_count : 1)
  name                   = lower(format("ptazsg-%s%02d", var.environment == "PROD" ? "1${var.projectname}asp" : var.environment == "UAT" ? "4${var.projectname}asp" : "5${var.projectname}asp", count.index + 1))
  resource_group_name    = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type                = "Linux"
  sku_name               = var.sku_size_linux
  zone_balancing_enabled = var.environment == "PROD" && var.zone_redundant
  worker_count           = var.linux_instance_count
  #app_service_environment_id = contains(local.sku_isolated_size, var.sku_size_linux) ? null : (var.environment == "PROD" && var.zone_redundant == "true" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE04-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    var.environment == "PROD" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE03-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    var.environment == "UAT" ? "/subscriptions/1c334150-08b8-4088-9170-074fa26a9926/resourceGroups/PTAZSG-IAC-UAT-ASE01-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-4iacase01" :
    "/subscriptions/2be5068f-e0ac-4d57-aedc-96bc9798a265/resourceGroups/PTAZSG-IAC-DEV-ASE02-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-5ase02"
  )

  tags = {
    environment = var.environment
    project     = var.projectname
  }
}

# Azure Service Plan for Windows Function Apps
resource "azurerm_service_plan" "aspwindows" {
  count               = var.windows_funcapp_count == 0 ? 0 : (var.app_service_plan == "separate" ? var.windows_funcapp_count : 1)
  name                = lower(format("ptazsg-%s%02d", var.environment == "PROD" ? "1${var.projectname}asp" : var.environment == "UAT" ? "4${var.projectname}asp" : "5${var.projectname}asp", var.linux_funcapp_count + count.index + 1))
  resource_group_name = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  os_type             = "Windows"
  sku_name            = var.sku_size_windows
  worker_count        = var.windows_instance_count
  #app_service_environment_id = contains(local.sku_isolated_size, var.sku_size_windows) ? null : (var.environment == "PROD" && var.zone_redundant == "true" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE04-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    var.environment == "PROD" ? "/subscriptions/e2c2906c-8901-4443-a9ee-50ffe123541a/resourceGroups/PTAZSG-IAC-PROD-ASE03-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-1iacase03" :
    var.environment == "UAT" ? "/subscriptions/1c334150-08b8-4088-9170-074fa26a9926/resourceGroups/PTAZSG-IAC-UAT-ASE01-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-4iacase01" :
    "/subscriptions/2be5068f-e0ac-4d57-aedc-96bc9798a265/resourceGroups/PTAZSG-IAC-DEV-ASE02-RG/providers/Microsoft.Web/hostingEnvironments/ptsg-5ase02"
  )
  tags = {
    environment = var.environment
    project     = var.projectname
  }
}


