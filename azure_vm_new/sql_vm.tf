data "azurerm_virtual_machine" "main" {
  count               = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  name                = azurerm_windows_virtual_machine.main.name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

resource "azurerm_mssql_virtual_machine" "main" {
  count              = local.effective_application_type[local.apptype] == "db" ? 1 : 0
  virtual_machine_id = data.azurerm_virtual_machine.main[0].id
  sql_license_type = "PAYG"
  storage_configuration {
    disk_type             = "NEW"
    storage_workload_type = "OLTP"

    data_settings {
      default_file_path = "F:\\data"
      luns              = [1]
    }
    log_settings {
      default_file_path = "G:\\log"
      luns              = [2]
    }
    temp_db_settings {
      default_file_path = "H:\\tempDb"
      luns              = [3]
    }
  }

  depends_on = [ azurerm_virtual_machine_data_disk_attachment.data_disk_attachment,azurerm_virtual_machine_data_disk_attachment.log_disk_attachment,azurerm_virtual_machine_data_disk_attachment.temp_disk_attachment]
}