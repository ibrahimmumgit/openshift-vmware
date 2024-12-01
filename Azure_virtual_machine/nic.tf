resource "azurerm_network_interface" "nic" {
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-${var.applicationtype}${local.next_vm_name}-nic" : var.environment == "UAT" ? "-4${local.effective_applicationname}-${var.applicationtype}${local.next_vm_name}-nic" : "-5${local.effective_applicationname}-${var.applicationtype}${local.next_vm_name}-nic"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.private_ip_address
  }
  tags = local.common_tags
}

data "azurerm_subnet" "example" {
  name                 = local.vm_subnet_name #var.subnet_name
  virtual_network_name = local.vm_vnet_name #"aadds-vnet" #var.virtual_network_name
  resource_group_name  = "RG-AKS-AzSHCI"
}


# Define all possible IPs in the subnet
locals {
  subnet_cidr      = data.azurerm_subnet.example.address_prefix
  private_ip_address = cidrhost(data.azurerm_subnet.example.address_prefixes[0], 11)
  }


# Pick the first available IP
output "private_ip_address" {
  value = local.private_ip_address
}