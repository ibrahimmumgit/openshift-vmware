# Storage account creation (conditionally created based on create_storage_account variable)
resource "azurerm_storage_account" "asa" {
  count                    = var.backup_enable && var.create_new_resource_group ? 1 : local.estorage_len == 0 && var.backup_enable ? 1 : 0
  name                     = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}str${var.account_replication_type}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}str${var.account_replication_type}" : "5${local.effective_applicationname}str${var.account_replication_type}"}")
  resource_group_name      = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                 = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = local.common_tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}


resource "azurerm_storage_container" "asc" {
  count = var.backup_enable && var.create_new_resource_group ? 1 : local.estorage_len == 0 && var.backup_enable ? 1 : 0
  name  = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}bkpcn" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}bkpcn" : "5${local.effective_applicationname}bkpcn"}")
  #storage_account_name  = var.backup_enable && var.create_new_resource_group ? azurerm_storage_account.asa[0].name : local.estorage_len == 0 && var.backup_enable ? azurerm_storage_account.asa[0].name : data.azurerm_storage_account.asa[0].name
  storage_account_name  = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}str${var.account_replication_type}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}str${var.account_replication_type}" : "5${local.effective_applicationname}str${var.account_replication_type}"}")
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.asa
  ]

}