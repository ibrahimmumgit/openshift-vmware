 # Get the appropriate VNet based on the environment
data "azurerm_virtual_network" "private_vnet" {
  name                = var.environment == "PROD" ? "PTAZSG-1IAC-AGWNET-VNET" : var.environment == "UAT" ? "PTAZSG-4IAC-AGWNET-VNET" : "PTAZSG-5AGWNET-VNET"
  resource_group_name = var.environment == "PROD" ? "PTAZSG-IAC-PROD-AGWNET-RG" : var.environment == "UAT" ? "PTAZSG-IAC-UAT-AGWNET-RG": "PTAZSG-IAC-DEV-AGWNET-RG"
}
 
# Get the appropriate Subnet based on the environment
data "azurerm_subnet" "private_subnet" {
  name                 = var.environment == "PROD" ? "PTAZSG-1SUBNET-AGW01-PRIVATE" : var.environment == "UAT" ? "PTAZSG-4SUBNET-AGW01-PRIVATE" : "PTAZSG-5SUBNET-AGW01-PRIVATE"
  virtual_network_name = data.azurerm_virtual_network.private_vnet.name
  resource_group_name = var.environment == "PROD" ? "PTAZSG-IAC-PROD-AGWNET-RG" : var.environment == "UAT" ? "PTAZSG-IAC-UAT-AGWNET-RG": "PTAZSG-IAC-DEV-AGWNET-RG"
}


data "azurerm_virtual_network" "public_vnet" {
  name                = var.environment == "PROD" ? "PTAZSG-1IAC-AGWNET-VNET" : var.environment == "UAT" ? "PTAZSG-4IAC-AGWNET-VNET" : "PTAZSG-5AGWNET-VNET"
  resource_group_name = var.environment == "PROD" ? "PTAZSG-IAC-PROD-AGWNET-RG" : var.environment == "UAT" ? "PTAZSG-IAC-UAT-AGWNET-RG": "PTAZSG-IAC-DEV-AGWNET-RG"
}
 
# Get the appropriate Subnet based on the environment
data "azurerm_subnet" "public_subnet" {
  name                 = var.environment == "PROD" ? "PTAZSG-1SUBNET-AGW01-PUBLIC" : var.environment == "UAT" ? "PTAZSG-4SUBNET-AGW01-PUBLIC" : "PTAZSG-5SUBNET-AGW01-PUBLIC"
  virtual_network_name = data.azurerm_virtual_network.public_vnet.name
  resource_group_name = var.environment == "PROD" ? "PTAZSG-IAC-PROD-AGWNET-RG" : var.environment == "UAT" ? "PTAZSG-IAC-UAT-AGWNET-RG": "PTAZSG-IAC-DEV-AGWNET-RG"
}


resource "azurerm_public_ip" "pip" {
  name                = var.environment == "PROD" ? "ptazsg-1agw${var.projectname}01-pip" : var.environment == "UAT" ? "ptazsg-4agw${var.projectname}01-pip": "ptazsg-5agw${var.projectname}01-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.environment == "PROD" ? ["1","2","3"] : ["1"]
}