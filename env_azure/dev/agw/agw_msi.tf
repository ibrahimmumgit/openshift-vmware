resource "azurerm_user_assigned_identity" "agw" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 
  name                = lower("ptazsg${var.environment == "PROD" ? "1-${var.projectname}agw1-secrets-msi" : var.environment == "UAT" ? "4-${var.projectname}agw4-secrets-msi" : "5-${var.projectname}agw5-secrets-msi"}")
}