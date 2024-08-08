locals {
  # is_user = contains(var.role_access, "@")
  is_user = can(regex("@", var.role_access))
}

data "azuread_user" "user" {
  count               = local.is_user ? 1 : 0
  user_principal_name = local.is_user ? var.role_access : null
}

data "azuread_group" "group" {
  count        = local.is_user ? 0 : 1
  display_name = local.is_user ? null : var.role_access
}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

resource "azurerm_role_assignment" "reader" {
  scope              = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].id : data.azurerm_resource_group.rg[0].id
  role_definition_id = data.azurerm_role_definition.reader.role_definition_id
  principal_id       = local.is_user ? data.azuread_user.user[0].object_id : data.azuread_group.group[0].object_id
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_storage_account.asa
  ]
}