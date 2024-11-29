resource "azurerm_role_assignment" "reader" {
  count              = var.create_new_resource_group ? 1 : 0
  scope              = var.create_new_resource_group ? azurerm_resource_group.rg[count.index].id : data.azurerm_resource_group.rg[count.index].id
  role_definition_id = data.azurerm_role_definition.custom[count.index].role_definition_id
  principal_id       = data.azuread_group.group[count.index].object_id
  depends_on = [
    azurerm_resource_group.rg,
  #  azurerm_storage_account.asa
  ]
}