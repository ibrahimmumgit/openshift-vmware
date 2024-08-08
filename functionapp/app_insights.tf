# Application Insights creation (conditionally created based on enable_monitoring and create_new_application_insigts variables)
resource "azurerm_log_analytics_workspace" "alaw" {
  count               = var.enable_monitoring == true && var.create_new_application_insigts == true ? 1 : 0
  name                = lower("ptazsg-${var.environment == "PROD" ? "1${var.projectname}alaw" : var.environment == "UAT" ? "4${var.projectname}alaw" : "5${var.projectname}alaw"}")
  resource_group_name = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = var.sku
  retention_in_days   = 30
}




resource "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring == true && var.create_new_application_insigts == true ? 1 : 0
  name                = lower("ptazsg-${var.environment == "PROD" ? "1${var.projectname}aai" : var.environment == "UAT" ? "4${var.projectname}aai" : "5${var.projectname}aai"}")
  resource_group_name = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  workspace_id        = azurerm_log_analytics_workspace.alaw[0].id
  application_type    = "other"
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_storage_account.asa
  ]
}

# Data source for existing Application Insights instance (used when create_new_application_insigts is false)
data "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring == true && var.create_new_application_insigts == false ? 1 : 0
  name                = var.application_insights_name
  resource_group_name = var.application_insights_resource_group_name
}
