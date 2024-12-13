# SQL Data Disk
resource "azurerm_managed_disk" "sql_data" {
  count                  = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  name                   = lower("ptsg${local.effective_environment == "PROD" ? "1${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}" : "5${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}"}_Data_Disk")
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  storage_account_type   = local.common_tags.CSBIA_Availability == "Severe" || local.common_tags.CSBIA_Availability == "Major" ? "Premium_ZRS" : "Standard_LRS"
  disk_size_gb           = var.data_disk_size1
  create_option          = "Empty"
  disk_encryption_set_id = data.azurerm_disk_encryption_set.disk_encryption.id
  tags                   = local.common_tags
  zone                   = var.zone
}

# SQL Log Disk
resource "azurerm_managed_disk" "sql_log" {
  count                  = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  name                   = lower("ptsg${local.effective_environment == "PROD" ? "1${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}" : "5${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}"}_Log_Disk")
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  storage_account_type   = local.common_tags.CSBIA_Availability == "Severe" || local.common_tags.CSBIA_Availability == "Major" ? "Premium_ZRS" : "Standard_LRS"
  disk_size_gb           = var.data_disk_size2
  create_option          = "Empty"
  disk_encryption_set_id = data.azurerm_disk_encryption_set.disk_encryption.id
  tags                   = local.common_tags
  zone                   = var.zone
}


# SQL Temp
resource "azurerm_managed_disk" "sql_temp" {
  count                  = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  name                   = lower("ptsg${local.effective_environment == "PROD" ? "1${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}" : "5${local.effective_applicationname}${local.effective_application_type[local.apptype]}${local.next_vm_name}"}_TempDB_Disk")
  resource_group_name    = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location               = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  storage_account_type   = local.common_tags.CSBIA_Availability == "Severe" || local.common_tags.CSBIA_Availability == "Major" ? "Premium_ZRS" : "Standard_LRS"
  disk_size_gb           = var.data_disk_size3
  create_option          = "Empty"
  disk_encryption_set_id = data.azurerm_disk_encryption_set.disk_encryption.id
  tags                   = local.common_tags
  zone                   = var.zone
}


# Attach SQL Data Disk
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count              = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.sql_data[0].id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  lun                = 1
  caching            = "ReadOnly"
  depends_on = [
    azurerm_managed_disk.sql_data
  ]
}

# Attach SQL Log Disk
resource "azurerm_virtual_machine_data_disk_attachment" "log_disk_attachment" {
  count              = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.sql_log[0].id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  lun                = 2
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.sql_log
  ]
}

# Attach SQL Log Disk
resource "azurerm_virtual_machine_data_disk_attachment" "temp_disk_attachment" {
  count              = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.sql_temp[0].id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  lun                = 3
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.sql_temp
  ]
}





