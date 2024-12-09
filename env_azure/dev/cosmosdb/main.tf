#Terraform code to cosmosdb nosql account
resource "azurerm_cosmosdb_account" "main" {
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}cosmosdb${local.next_cosmosdb_account_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}cosmosdb${local.next_cosmosdb_account_name}" : "-5${local.effective_applicationname}cosmosdb${local.next_cosmosdb_account_name}"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  offer_type          = var.offer_type
  kind                = var.kind
  #ip_range_filter                       = var.allowed_ip_range_cidrs != null ? join(",", var.allowed_ip_range_cidrs) : null
  minimal_tls_version              = var.minimum_tls_version
  free_tier_enabled                = var.free_tier_enabled
  public_network_access_enabled    = var.allow_access_from 
  multiple_write_locations_enabled = var.capacity_mode && var.multi_write_enabled ? true : false
  # Backup configuration
  backup {
    type = var.type
    # Only include these if the type is "Periodic"
    tier                = var.type != "Periodic" ? var.tier : null # or Continuous7Days
    interval_in_minutes = var.type == "Periodic" ? var.interval_in_minutes : null
    retention_in_hours  = var.type == "Periodic" ? var.retention_in_hours : null
    storage_redundancy  = var.type == "Periodic" ? var.storage_redundancy : null
  }

  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }

  geo_location {
    location          = var.geo_location
    failover_priority = 0
  }

  key_vault_key_id = (var.create_new_resource_group && !var.data_encryption_type) || var.create_new_key_vault ? (
    length(azurerm_key_vault_key.vault_key) > 0 ? azurerm_key_vault_key.vault_key[0].versionless_id :
    length(data.azurerm_key_vault_key.vault_key) > 0 ? data.azurerm_key_vault_key.vault_key[0].versionless_id : null
  ) : null
  dynamic "virtual_network_rule" {
    for_each = !var.public_network_access_enabled && var.allow_access_from ? [1] : []
    content {
      id = data.azurerm_subnet.kv_subnet[0].id
      #ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
    }
  }


  dynamic "capabilities" {
    for_each = !var.capacity_mode ? [1] : []
    content {
      name = "EnableServerless"
    }
  }

  capacity {
    total_throughput_limit = var.enable_throughput_limit ? var.total_throughput_limit : -1
  }

  # Optional default identity for Key Vault access
  #  default_identity_type = var.data_encryption_type ? "FirstPartyIdentity" : join("=", ["UserAssignedIdentity", var.create_new_identity_access ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id]) 

  default_identity_type = var.data_encryption_type ? "FirstPartyIdentity" : !var.data_encryption_type && var.identity ? join("=", ["UserAssignedIdentity", var.create_new_identity_access ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id]) : "FirstPartyIdentity"
  identity {
    type         = !var.data_encryption_type && var.identity ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = !var.data_encryption_type && var.identity ? [var.create_new_identity_access ? azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id] : null
  }

  tags = local.common_tags

  lifecycle {
    ignore_changes = [name]
  }
  depends_on = [azurerm_key_vault.vault,
    azurerm_key_vault_access_policy.terraform_user_policy,
    azurerm_key_vault_access_policy.cosmosdb_service,
    azurerm_key_vault_key.vault_key,
    azurerm_key_vault_access_policy.user_identity_access
  ]
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}cosnosqldb${local.next_cosmosdb_account_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}cosnosqldb${local.next_cosmosdb_account_name}" : "-5${local.effective_applicationname}cosnosqldb${local.next_cosmosdb_account_name}"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  account_name        = azurerm_cosmosdb_account.main.name
  lifecycle {
    ignore_changes = [name]
  }
  # Set provisioned throughput for the database
  #throughput = var.enable_throughput_limit ? var.total_throughput_limit : null
}


#---------------------------------------------------------
#  CosmosDB SQL Container API - Default is "false" 
#---------------------------------------------------------
 resource "azurerm_cosmosdb_sql_container" "main" {
   # count                  = var.create_cosmosdb_sql_container ? 1 : 0
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}cosmosdb${local.next_cosmosdb_account_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}cosmosdb${local.next_cosmosdb_account_name}" : "-5${local.effective_applicationname}cosmosdb${local.next_cosmosdb_account_name}"}")
   resource_group_name   = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
   account_name          = azurerm_cosmosdb_account.main.name
   database_name         = azurerm_cosmosdb_sql_database.db.name
   partition_key_paths   = var.partition_key_path
   partition_key_version = var.partition_key_version
  lifecycle {
    ignore_changes = [name]
  }
   #throughput            = var.enable_throughput_limit ? var.total_throughput_limit : null
   # default_ttl            = var.default_ttl
   # analytical_storage_ttl = var.analytical_storage_ttl
 }


#-------------------------------------------------------------
#  CosmosDB azure defender configuration - Default is "false" 
#-------------------------------------------------------------
resource "azurerm_advanced_threat_protection" "defender" {
  count              = var.enable_advanced_threat_protection ? 1 : 0
  target_resource_id = azurerm_cosmosdb_account.main.id
  enabled            = var.enable_advanced_threat_protection
}

