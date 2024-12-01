# Create a Windows Virtual Machine with disk encryption, boot diagnostics, and a managed network interface
resource "azurerm_windows_virtual_machine" "main" {
  name                  = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}${var.applicationtype}${local.next_vm_name}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}${var.applicationtype}${local.next_vm_name}" : "5${local.effective_applicationname}${var.applicationtype}${local.next_vm_name}"}")
  resource_group_name   = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location              = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  size                  = var.vm_size
  admin_username        = "manager"
  admin_password        = data.azurerm_key_vault_secret.admin_password.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  zone                  = var.zone
  patch_mode            = "Manual" 
  enable_automatic_updates = false
  license_type          = "Windows_Server"
  os_disk {
    caching                = var.os_disk_caching
    storage_account_type   = local.common_tags.CSBIA_Availability == "Severe" || local.common_tags.CSBIA_Availability == "Major" ? "Premium_ZRS" : "Standard_LRS" 
    disk_encryption_set_id = var.create_disk_encryption ? azurerm_disk_encryption_set.disk_encryption[0].id : data.azurerm_disk_encryption_set.disk_encryption[0].id
    disk_size_gb           = 127
  }
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
  identity {
    type         = var.identity_access ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_access ? null : [var.create_new_identity_access && var.identity_name == null ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id]
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
  tags = local.common_tags

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_disk_encryption_set.disk_encryption, # Ensure disk encryption set is created first
    azurerm_managed_disk.data_disk                  # Ensure data disk is created before VM attachment
  ]
}

# Time delay to wait before destroying the VM to ensure proper cleanup
resource "time_sleep" "vm" {
  destroy_duration = "180s"                                 # Wait for 180 seconds before destroying the VM
  depends_on       = [azurerm_windows_virtual_machine.main] # Ensure VM is created before starting the wait time
}
