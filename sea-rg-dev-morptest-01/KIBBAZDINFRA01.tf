# # For linux machine please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

# # For windows machine please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine

# Create a Network Interface for KIBBAZDINFRA01
resource "azurerm_network_interface" "KIBBAZDINFRA01" {
  name                = "KIBBAZDINFRA01-nic"
  location            = azurerm_resource_group.sea-rg-dev-morptest-01.location
  resource_group_name = azurerm_resource_group.sea-rg-dev-morptest-01.name
  depends_on          = [azurerm_resource_group.sea-rg-dev-morptest-01]
  tags                = var.vm_tags

  ip_configuration {
    name                          = "KIBBAZDINFRA01-nic-ip"
    subnet_id                     = data.azurerm_subnet.AppSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine for KIBBAZDINFRA01
resource "azurerm_linux_virtual_machine" "KIBBAZDINFRA01" {
  name                            = "KIBBAZDINFRA01"
  resource_group_name             = azurerm_resource_group.sea-rg-dev-morptest-01.name
  location                        = azurerm_resource_group.sea-rg-dev-morptest-01.location
  size                            = "Standard_D2s_v5"
  admin_username                  = var.adminuser
  admin_password                  = var.adminpass
  disable_password_authentication = "false"
  network_interface_ids           = [azurerm_network_interface.KIBBAZDINFRA01.id, ]
  tags                            = var.vm_tags
  patch_assessment_mode           = "ImageDefault"
  patch_mode                      = "ImageDefault"
#  depends_on                      = [azurerm_network_interface.KIBBAZDINFRA01, azurerm_storage_account.seastdevinfrabd01]
  encryption_at_host_enabled      = "true"

  os_disk {
    name                 = "KIBBAZDINFRA01_osDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = "128"
#    disk_encryption_set_id = azurerm_disk_encryption_set.sea-des-dev-infra-01.id
  }

 source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "8.8.2023081717"
  }

#  boot_diagnostics {
#    #enabled = "true"
#    storage_account_uri = azurerm_storage_account.seastdevinfrabd01.primary_blob_endpoint
#  }

  identity {
     identity_ids = []
     type         = "SystemAssigned"
   }
}
 #Enable Azure Extension for KIBBAZDINFRA01
# resource "azurerm_virtual_machine_extension" "AMWA01" {
#   name                       = "AzureMonitorLinuxAgent"
#   virtual_machine_id         = azurerm_linux_virtual_machine.KIBBAZDINFRA01.id
#   publisher                  = "Microsoft.Azure.Monitor"
#   type                       = "AzureMonitorLinuxAgent"
#   type_handler_version       = "1.9"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = true
# }

# resource "azurerm_virtual_machine_extension" "MDE01" {
#   name                        = "MDE.Linux"
#   virtual_machine_id          = azurerm_linux_virtual_machine.KIBBAZDINFRA01.id
#   publisher                   = "Microsoft.Azure.AzureDefenderForServers"
#   type                        = "MDE.Linux"
#   type_handler_version        = "1.0"
#   failure_suppression_enabled = true
# }