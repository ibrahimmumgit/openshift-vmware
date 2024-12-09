resource "azurerm_resource_group" "rg" {
  name     = upper("PTAZSG-IAC-${var.environment}-${var.projectname}-RG")
  location = var.location
}