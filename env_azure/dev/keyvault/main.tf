# create key vault
resource "azurerm_key_vault" "main" {
  #name                            = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}kv${local.next_key_vault_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}kv${local.next_key_vault_name}" : "-5${local.effective_applicationname}kv${local.next_key_vault_name}"}")
  name                            =  upper("${local.prefix}-kv${local.next_key_vault_name}")
  resource_group_name             = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                        = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.rbac_authorization
  purge_protection_enabled        = var.purge_protection
  public_network_access_enabled   = var.public_network_access_enabled
  dynamic "network_acls" {
    for_each = var.public_network_access_enabled && var.allow_access_from ? [1] : []
      content {
      bypass = var.bypass
      default_action              = var.default_action
      #ip_rules                    = length(var.allowed_ip_addresses) > 0 ? var.allowed_ip_addresses : [] #var.allowed_ip_addresses
      virtual_network_subnet_ids  = [data.azurerm_subnet.kv_subnet.id]
    }
  }
  tags                            = local.common_tags
} 

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  count                           = var.rbac_authorization ? 0 : 1
  key_vault_id                    = azurerm_key_vault.main.id
  object_id                       = data.azuread_group.access_policy_group_name[0].object_id #data.azurerm_client_config.current.object_id
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  key_permissions                 = local.selected_key_permissions
  secret_permissions              = local.selected_secret_permissions 
}
