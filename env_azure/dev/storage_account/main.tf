# Storage account creation (conditionally created based on create_storage_account variable)
resource "azurerm_storage_account" "main" {
  name                          = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}str${var.account_replication_type}${local.next_storage_account_name}" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}str${var.account_replication_type}${local.next_storage_account_name}" : "5${local.effective_applicationname}str${var.account_replication_type}${local.next_storage_account_name}"}")
  resource_group_name           = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                      = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  account_kind                  = var.account_kind
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = var.allow_access_from
  https_traffic_only_enabled    = true
  allow_nested_items_to_be_public   = false 

  // routing {
  //   choice = "MicrosoftRouting" # Can be "InternetRouting" or "MicrosoftRouting"
  // }

  dynamic "network_rules" {
    for_each = var.public_network_access_enabled && !var.allow_access_from ? [1] : []
    content {
      default_action             = var.default_action
      virtual_network_subnet_ids = data.azurerm_subnet.sa_subnet[0].id
      #ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
    }
  }


  dynamic "blob_properties" {
    for_each = ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ? [1] : [])
    content {
      versioning_enabled       = var.blob_versioning_enabled
      last_access_time_enabled = var.blob_last_access_time_enabled

      dynamic "delete_retention_policy" {
        for_each = (var.blob_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.blob_delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = (var.container_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.container_delete_retention_days
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      customer_managed_key,
      name
    ]
  }

  identity {
    type         = !var.data_encryption_type && var.identity_access ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = !var.data_encryption_type && var.identity_access ? [var.create_new_identity_access ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id] : null
  }

  tags = local.common_tags

}


# Customer Managed Key for Storage Account
resource "azurerm_storage_account_customer_managed_key" "cmk" {
  count                     = !var.data_encryption_type ? 1 : 0
  storage_account_id        = azurerm_storage_account.main.id
  user_assigned_identity_id = var.identity_access ? (var.create_new_identity_access ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id) : null
  key_name                  = data.azurerm_key_vault_key.vault_key.name
  key_vault_id              = data.azurerm_key_vault.vault.id 
  depends_on = [ azurerm_key_vault_access_policy.storage_policy ]
}

# Storage Container
resource "azurerm_storage_container" "container" {
  count                 = var.create_container ? 1 : 0
  name                  = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}cn" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}cn" : "5${local.effective_applicationname}cn"}")
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.container_access_type

  depends_on = [azurerm_storage_account.main]
}

# File Share
resource "azurerm_storage_share" "FSShare" {
  count                = var.create_fsshare ? 1 : 0
  name                 = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}fs" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}fs" : "5${local.effective_applicationname}fs"}")
  storage_account_name = azurerm_storage_account.main.name
  quota                = var.quota

  depends_on = [azurerm_storage_account.main]
}