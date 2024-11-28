/*
# Data source to fetch pubip in a specific resource group
data "azurerm_resources" "pubip" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  # Filter to get only resources of type Microsoft.Network/publicIPAddresses
  type = "Microsoft.Network/publicIPAddresses"
}
*/

# Fetch public IP that is to be added to Azure load balance frontend
data "azurerm_public_ip" "pubip01" {
  count               = var.is_public == true ? 1 : 0
  name                = var.pubip01_name
  resource_group_name = var.pubip_resource_group_name
}

data "azurerm_public_ip" "pubip02" {
  count               = var.is_public == true && var.frontend_count >= 2 ? 1 : 0
  name                = var.pubip02_name
  resource_group_name = var.pubip_resource_group_name
}

# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}

# Data source to fetch lb in a specific resource group
data "azurerm_resources" "lb" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  # Filter to get only resources of type Microsoft.Network/loadBalancers
  type = "Microsoft.Network/loadBalancers"
}

#network Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "lb_vnet" {
  #count               = var.is_public == false ? 1 : 0
  name                = local.lb_vnet_name
  resource_group_name = var.lb_vnet_resource_group_name
}
 
# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "lb_subnet" {
  #count               = var.is_public == false ? 1 : 0
  name                 = local.lb_subnet_name
  virtual_network_name = data.azurerm_virtual_network.lb_vnet.name
  resource_group_name  = var.lb_vnet_resource_group_name
}

# VM network interface id
data "azurerm_network_interface" "fe01_be01_vm01_nic" {
  count               = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 && var.fe01_be01_vm_count >= 1 ? 1 : 0
  name                = var.fe01_be01_vm01_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe01_be01_vm02_nic" {
  count               = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 && var.fe01_be01_vm_count >= 2 ? 1 : 0
  name                = var.fe01_be01_vm02_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe01_be02_vm01_nic" {
  count               = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 && var.fe01_be02_vm_count >= 1 ? 1 : 0
  name                = var.fe01_be02_vm01_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe01_be02_vm02_nic" {
  count               = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 && var.fe01_be02_vm_count >= 2 ? 1 : 0
  name                = var.fe01_be02_vm02_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe02_be01_vm01_nic" {
  count               = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 && var.fe02_be01_vm_count >= 1 ? 1 : 0
  name                = var.fe02_be01_vm01_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe02_be01_vm02_nic" {
  count               = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 && var.fe02_be01_vm_count >= 2 ? 1 : 0
  name                = var.fe02_be01_vm02_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe02_be02_vm01_nic" {
  count               = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 && var.fe02_be02_vm_count >= 1 ? 1 : 0
  name                = var.fe02_be02_vm01_interface_name
  resource_group_name = var.vm_resource_group_name
}
data "azurerm_network_interface" "fe02_be02_vm02_nic" {
  count               = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 && var.fe02_be02_vm_count >= 2 ? 1 : 0
  name                = var.fe02_be02_vm02_interface_name
  resource_group_name = var.vm_resource_group_name
}

# Data source to read all resources
data "azurerm_resources" "all" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

# Data source to retrieve the client configuration
data "azurerm_client_config" "current" {}
/*
data "azuread_group" "group" {
  count        = var.create_new_resource_group ? 1 : 0
  display_name = var.role_access
}

data "azurerm_role_definition" "custom" {
  count = var.create_new_resource_group && var.custom_role_name != null ? 1 : 0
  name  = var.custom_role_name
  scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
*/


