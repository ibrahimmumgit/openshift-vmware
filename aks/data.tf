data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}

data "azurerm_resources" "aks" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filters to find only AKS clusters
  type = "Microsoft.ContainerService/managedClusters"
}


data "azurerm_log_analytics_workspace" "alaw" {
  count               = !var.create_new_application_insigts && var.enable_monitoring ? 1 : 0
  name                = var.existing_log_analytics_workspace
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

}

# Data source to retrieve the client configuration
data "azurerm_client_config" "current" {}

# data "azuread_group" "group" {
#   count        = var.create_new_resource_group ? 1 : 0
#   display_name = var.role_access
# }

# data "azuread_group" "group_rbac" {
#   count        = var.enable_rbac ? 1 : 0
#   display_name = var.group_name
# }

# data "azurerm_role_definition" "custom" {
#   count = var.create_new_resource_group && var.custom_role_name != null ? 1 : 0
#   name  = var.custom_role_name
#   scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
# }


#network
# # Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "aks_vnet" {
  name                = local.aks_vnet_name
  resource_group_name = var.resource_group_name_aks_vnet
}

# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "aks_subnet" {
  name                 = local.aks_subnet_name
  virtual_network_name = data.azurerm_virtual_network.aks_vnet.name
  resource_group_name  = var.resource_group_name_aks_vnet
}




