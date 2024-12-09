resource "azurerm_private_endpoint" "private_endpoint" {
  count               = !var.public_network_access_enabled && !var.allow_access_from  ? 1 : 0
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-stg${local.next_storage_account_name}-pep" : var.environment == "UAT" ? "-4${local.effective_applicationname}-stg${local.next_storage_account_name}-pep" : "-5${local.effective_applicationname}-stg${local.next_storage_account_name}-pep"}")
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  subnet_id           = data.azurerm_subnet.pv_subnet[0].id


  private_service_connection {
    name                           = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-psc" : var.environment == "UAT" ? "-4${local.effective_applicationname}-psc" : "-5${local.effective_applicationname}-psc"}")
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = var.account_kind == "FileStorage" ? ["File"] : ["blob"]
  }
  tags = local.common_tags

}
