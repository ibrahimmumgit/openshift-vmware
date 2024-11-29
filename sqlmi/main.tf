# SQL Managed Instance
resource "azurerm_mssql_managed_instance" "main" {
  name                         = lower("${var.rg_prefix}${(local.effective_environment == "PROD") ? "-1${local.effective_applicationname}${local.next_sql_mi_name}" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}${local.next_sql_mi_name}" : "-5${local.effective_applicationname}${local.next_sql_mi_name}"}")
  resource_group_name          = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                     = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  subnet_id                    = data.azurerm_subnet.sql_subnet.id
  administrator_login          = var.administrator_login
  administrator_login_password = data.azurerm_key_vault_secret.sql_admin_password.value
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
  storage_account_type         = var.storage_account_type
  zone_redundant_enabled       = var.zone_redundant
  timezone_id                  = var.timezone_id 

  identity {
    type         = var.identity_access ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_access ? null : [var.create_new_identity_access && var.identity_name == null ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id]
  }

  public_data_endpoint_enabled = var.public_data_endpoint_enabled

  lifecycle { ignore_changes = [name] }


  tags = local.common_tags

  depends_on = [
    azurerm_key_vault_secret.kvs
  ]
}