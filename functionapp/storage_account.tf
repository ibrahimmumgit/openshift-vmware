# Storage account creation (conditionally created based on create_storage_account variable)
resource "azurerm_storage_account" "asa" {
  count                           = var.create_storage_account == true ? 1 : 0
  name                            = lower("ptazsg${var.environment == "PROD" ? "1${var.projectname}str${var.account_replication_type}" : var.environment == "UAT" ? "4${var.projectname}str${var.account_replication_type}" : "5${var.projectname}str${var.account_replication_type}"}")
  resource_group_name             = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                        = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  account_kind                    = var.account_kind
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = {
    environment = var.environment
    project     = var.projectname
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Data source for existing storage account (used when create_storage_account is false)
data "azurerm_storage_account" "asa" {
  count               = var.create_storage_account == false ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}
