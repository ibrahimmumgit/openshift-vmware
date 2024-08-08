# Resource group creation (conditionally created based on create_new_resource_group variable)
resource "azurerm_resource_group" "rg" {
  count    = var.create_new_resource_group == true ? 1 : 0
  name     = upper("PTAZSG-IAC-${var.environment}-${var.projectname}-RG")
  location = var.location
  tags = {
    environment = var.environment
    project     = var.projectname
  }
}

# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}