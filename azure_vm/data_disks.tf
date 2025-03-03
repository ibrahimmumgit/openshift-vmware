resource "azurerm_managed_disk" "data_disk" {
  count = var.create_new_data_disk ? var.data_disk_count : 0
  name = lower(
    format(
      "%s%s%s%s-dd%02d",
      var.rg_prefix,
      var.applicationname,
      var.applicationtype,      
      local.next_vm_name,
      count.index + 1
    )
  )
  resource_group_name  = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location             = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  storage_account_type = "Standard_LRS"
  disk_size_gb         = var.data_disk_size
  create_option        = "Empty"
  #disk_encryption_set_id = var.create_disk_encryption ? azurerm_disk_encryption_set.disk_encryption[0].id : data.azurerm_disk_encryption_set.disk_encryption[0].id
  #tags                   = local.common_tags
}

