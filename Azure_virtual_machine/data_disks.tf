resource "azurerm_managed_disk" "data_disk" {
  count = var.create_new_data_disk ? var.data_disk_count : 0
  name = lower(
    format(
      "%s%s-%s-%s%s-dd%02d",
      var.rg_prefix,
      local.effective_environment == "PROD" ? "1" : local.effective_environment == "UAT" ? "4" : "5",
      local.effective_applicationname,
      var.applicationtype,
      local.next_vm_name,
      count.index + 1
    )
  )
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  storage_account_type   = local.common_tags.CSBIA_Availability == "Severe" || local.common_tags.CSBIA_Availability == "Major" ? "Premium_ZRS" : "Standard_LRS"
  disk_size_gb           = var.data_disk_size
  create_option          = "Empty"
  disk_encryption_set_id = var.create_disk_encryption ? azurerm_disk_encryption_set.disk_encryption[0].id : data.azurerm_disk_encryption_set.disk_encryption[0].id
  tags                   = local.common_tags
  zone                   = var.zone
  depends_on             = [azurerm_key_vault.vault, azurerm_key_vault_access_policy.disk_encryption_access_policy]
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count              = var.create_new_data_disk ? var.data_disk_count : 0
  managed_disk_id    = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  lun                = count.index # Logical Unit Number (LUN) is based on index
  caching            = "ReadWrite"
  depends_on = [
    azurerm_disk_encryption_set.disk_encryption,
    azurerm_managed_disk.data_disk
  ]

}
