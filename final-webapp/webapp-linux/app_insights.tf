# Application Insights creation (conditionally created based on enable_monitoring and create_new_application_insigts variables)
resource "azurerm_log_analytics_workspace" "alaw" {
  count               = var.enable_monitoring && var.create_new_application_insigts ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-log" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-log" : "-5${local.effective_applicationname}-log"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = var.sku
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring && var.create_new_application_insigts ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-appins" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-appins" : "-5${local.effective_applicationname}-appins"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  workspace_id        = azurerm_log_analytics_workspace.alaw[0].id
  application_type    = "other"
  tags                = local.common_tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}