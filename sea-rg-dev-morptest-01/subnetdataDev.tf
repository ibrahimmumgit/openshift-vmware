# Getting info for existing resource group
data "azurerm_resource_group" "sea-rg-dev-ss-vnet-01" {
  name = "sea-rg-dev-ss-vnet-01"
}

output "name" {
  value = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

# Getting info for existing Subnet
data "azurerm_subnet" "WebSubnet" {
  name                 = "WebSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "AGWSubnet" {
  name                 = "AGWSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "APMSubnet" {
  name                 = "APMSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "AppSubnet" {
  name                 = "AppSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "DBSSubnet" {
  name                 = "DBSSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "LBSubnet" {
  name                 = "LBSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "Default" {
  name                 = "Default"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

data "azurerm_subnet" "PESubnet" {
  name                 = "PESubnet"
  virtual_network_name = "sea-vnet-dev-ss-net-01"
  resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
}

# data "azurerm_subnet" "MySQLFlexiSubnet" {
#   name                 = "MySQLFlexiSubnet"
#   virtual_network_name = "sea-vnet-dev-ss-net-01"
#   resource_group_name  = data.azurerm_resource_group.sea-rg-dev-ss-vnet-01.name
# }