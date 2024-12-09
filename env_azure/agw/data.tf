# Fetch WAF Policy that is to be added to Azure load balance frontend
data "azurerm_web_application_firewall_policy" "waf01" {
  count               = var.agw_sku == "WAF_v2" ? 1 : 0
  name                = var.waf01_name
  resource_group_name = var.waf01_resource_group_name
}
/*
# Fetch public IP that is to be added to Azure load balance frontend
data "azurerm_public_ip" "pubip01" {
  name                = var.pubip01_name
  resource_group_name = var.pubip_resource_group_name
}
*/
# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}
# Data source to fetch appgateway in a specific resource group
data "azurerm_resources" "agw" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  type = "microsoft.network/applicationgateways"
}

# Data source to fetch publicip in a specific resource group
data "azurerm_resources" "pubip" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  type = "microsoft.network/publicipaddresses"
}

#network Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "agw_vnet" {
  #count               = var.is_public == false ? 1 : 0
  name                = local.agw_vnet_name
  resource_group_name = var.agw_vnet_resource_group_name
}

# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "agw_subnet" {
  #count               = var.is_public == false ? 1 : 0
  name                 = local.agw_subnet_name
  virtual_network_name = data.azurerm_virtual_network.agw_vnet.name
  resource_group_name  = var.agw_vnet_resource_group_name
}

# Data source to read all resources
data "azurerm_resources" "all" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}
# Data source to retrieve the client configuration
data "azurerm_client_config" "current" {}

# Fetch log_analytics_workspace that is to be added to Azure app gateway
data "azurerm_log_analytics_workspace" "alaw" {
  count               = var.enable_monitoring && var.create_new_log_analytics_workspace != true ? 1 : 0
  name                = var.existing_log_analytics_workspace_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

data "azuread_group" "group" {
  count        = var.create_new_resource_group ? 1 : 0
  display_name = var.role_access
}
 
data "azurerm_role_definition" "custom" {
  count = var.create_new_resource_group && var.custom_role_name != null ? 1 : 0
  name  = var.custom_role_name
  scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}