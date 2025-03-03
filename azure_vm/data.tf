# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}


# Data source to read all resources
data "azurerm_resources" "all" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

data "azurerm_resources" "vm" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filters to find only vms
  type = "Microsoft.Compute/virtualMachines"
}




#network
# # Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "vm_vnet" {
  name                = local.vm_vnet_name
  resource_group_name = var.resource_group_name_vm_vnet
}

# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "vm_subnet" {
  name                 = local.vm_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.name
  resource_group_name  = var.resource_group_name_vm_vnet
}