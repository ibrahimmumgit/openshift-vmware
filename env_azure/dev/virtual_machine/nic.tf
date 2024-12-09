resource "azurerm_network_interface" "nic" {
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-nic" : var.environment == "UAT" ? "-4${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-nic" : "-5${local.effective_applicationname}-${local.effective_application_type[local.apptype]}${local.next_vm_name}-nic"}")
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
 
 
# Pick the first available IP
output "private_ip_address" {
  value = local.private_ip_address
}