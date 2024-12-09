resource "azurerm_user_assigned_identity" "uai" {
  count               = var.create_new_identity_access ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-msi" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-msi" : "-5${local.effective_applicationname}-msi"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  tags                = local.common_tags
}


