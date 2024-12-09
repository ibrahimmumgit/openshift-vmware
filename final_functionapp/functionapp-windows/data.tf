# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}


# Data source to fetch all resources in a specific resource group
data "azurerm_resources" "existing_funcapps" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filter to get only resources of type Microsoft.Web/sites
  type = "Microsoft.Web/sites"
}

# Data source to fetch serviceplan  in a specific resource group
data "azurerm_resources" "app_service_plans" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filter to get only resources of type Microsoft.Web/serverfarms
  type = "Microsoft.Web/serverfarms"
}

data "azurerm_service_plan" "details" {
  count               = var.create_new_service_plan ? 0 : 1
  name                = var.serviceplan_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

# Data source to fetch storage account in a specific resource group
data "azurerm_resources" "storage_aacount" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filter to get only resources of type Microsoft.Web/serverfarms
  type = "Microsoft.Storage/storageAccounts"
}

# Data source to read all resources
data "azurerm_resources" "all" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}






# Data source to read the windows function app names from the file
data "local_file" "fwindows_function_app_names_from_file" {
  count    = fileexists("windows_function_app_names.txt") ? 1 : 0
  filename = "${path.module}/windows_function_app_names.txt"
}
# Data source for existing Application Insights instance (used when create_new_application_insigts is false)
data "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring && var.create_new_application_insigts != true ? 1 : 0
  name                = var.application_insights_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}
# Data source to retrieve the client configuration
data "azurerm_client_config" "current" {}



