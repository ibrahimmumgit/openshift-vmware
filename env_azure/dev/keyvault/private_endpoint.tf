resource "azurerm_private_endpoint" "private_endpoint" {
  count                            = var.private_endpoint ? 1 : 0
  #name                             = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-pep" : var.environment == "UAT" ? "-4${local.effective_applicationname}-pep" : "-5${local.effective_applicationname}-pep"}")
  name                             = "${local.prefix}-kv${local.next_key_vault_name}-pep"
  location                         = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  resource_group_name              = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  subnet_id                        = data.azurerm_subnet.pv_subnet[0].id

  private_service_connection {
    #name                           = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-psc" : var.environment == "UAT" ? "-4${local.effective_applicationname}-psc" : "-5${local.effective_applicationname}-psc"}")
    name                           = "${local.prefix}-kv${local.next_key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
  tags                             = local.common_tags
  dynamic "private_dns_zone_group" {
    for_each = var.integrate_with_private_dns_zone ? [1] : []
    content {
      #name                 = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}-dzg" : var.environment == "UAT" ? "-4${local.effective_applicationname}-dzg" : "-5${local.effective_applicationname}-dzg"}")
      name                 = "${local.prefix}-dzg"
      private_dns_zone_ids = var.private_dns_zone_ids != null && length(var.private_dns_zone_ids) > 0 ? var.private_dns_zone_ids : []
    }
  }
}
