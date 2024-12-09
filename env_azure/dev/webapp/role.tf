resource "azurerm_role_assignment" "reader" {
  count              = var.create_new_resource_group && var.custom_role_name != null ? 1 : 0
  scope              = var.create_new_resource_group ? azurerm_resource_group.rg[count.index].id : data.azurerm_resource_group.rg[count.index].id
  role_definition_id = data.azurerm_role_definition.custom[count.index].role_definition_id
  principal_id       = data.azuread_group.group[count.index].object_id
  depends_on = [
    azurerm_linux_web_app.webapp_linux,
    azurerm_windows_web_app.webapp_windows
  ]
}