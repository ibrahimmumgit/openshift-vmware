# Resource group creation (conditionally created based on create_new_resource_group variable)
resource "azurerm_resource_group" "rg" {
  count    = var.create_new_resource_group ? 1 : 0
  name     = upper("${var.rg_prefix}${var.applicationtype}-RG")
  location = var.location
  tags     = local.common_rg_tags
}

