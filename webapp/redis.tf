

# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "rediscache" {
  count                = var.enable_redis_cache ? 1 : 0
  name                 = lower("${var.rg_prefix}-${local.effective_environment == "PROD" ? "1${local.effective_applicationname}rc" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}rc" : "5${local.effective_applicationname}rc"}")
  resource_group_name  = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location             = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  capacity             = 1
  family               = var.account_tier == "Standard" ? "C" : "P"
  sku_name             = var.account_tier
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
  tags                 = local.common_tags
}
