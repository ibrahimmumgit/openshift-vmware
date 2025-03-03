# Create a Windows Virtual Machine with disk encryption, boot diagnostics, and a managed network interface
resource "azurerm_windows_virtual_machine" "main" {
  name                     = lower("${var.rg_prefix}${var.applicationname}${var.applicationtype}${local.next_vm_name}")
  resource_group_name      = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                 = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  size                     = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  network_interface_ids    = [azurerm_network_interface.nic.id]
  patch_assessment_mode    = "ImageDefault"
  patch_mode               = "Manual"
  enable_automatic_updates = false
  license_type             = "Windows_Server"
  os_disk {
    name                 = "${var.rg_prefix}${var.applicationname}${var.applicationtype}${local.next_vm_name}_osDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 128
  }
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
  identity {
    type = "SystemAssigned"
  }
  boot_diagnostics {
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      name
    ]
  }

  # Tags for resource organization
  tags = local.common_vm_tags


}

# Time delay to wait before destroying the VM to ensure proper cleanup
resource "time_sleep" "vm" {
  destroy_duration = "180s"                                 # Wait for 180 seconds before destroying the VM
  depends_on       = [azurerm_windows_virtual_machine.main] # Ensure VM is created before starting the wait time
}
