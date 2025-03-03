resource "azurerm_network_interface" "nic" {
  name                = lower("${var.rg_prefix}${var.applicationname}${var.applicationtype}${local.next_vm_name}-nic")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location

  ip_configuration {
    name                          = lower("${var.rg_prefix}${var.applicationname}${var.applicationtype}${local.next_vm_name}-nic-ip")
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  #tags = local.common_tags
}



