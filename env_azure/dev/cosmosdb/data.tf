# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}

# Data source to read all resources
data "azurerm_resources" "all" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

data "azurerm_resources" "cosmosdb" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filters to find only cosmosdb account
  type = "Microsoft.DocumentDB/databaseAccounts"
}


# Data source to retrieve the client configuration
data "azurerm_client_config" "current" {}


data "azuread_group" "group" {
   count        = var.create_new_resource_group ? 1 : 0
   display_name = var.role_access
  }

data "azurerm_role_definition" "custom" {
    count = var.create_new_resource_group && var.custom_role_name != null ? 1 : 0
    name  = var.custom_role_name
    scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
 }


// data "azuread_service_principal" "cosmosdb_sp" {
//   display_name = "Azure Cosmos DB"  
// }

 
 
data "azurerm_key_vault" "vault" {
  count               = (!var.create_new_resource_group && !var.create_new_key_vault && var.key_vault_name != null) ? 1 : 0
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  name                = var.key_vault_name #"cosmosdb-kv1" # Specify the name of your existing Key Vault
}


# Data source for the key in the Key Vault
data "azurerm_key_vault_key" "vault_key" {
  count        = var.key_name != null && var.key_name != "" ? 1 : 0
  name         = var.key_name # Specify the name of the key you want to retrieve
  key_vault_id = data.azurerm_key_vault.vault[0].id
}


# Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "kv_vnet" {
  count               = !var.public_network_access_enabled && var.allow_access_from ? 1 : 0
  name                = local.kv_vnet_name                    # Replace with your VNet name
  resource_group_name = var.resource_group_name_public_access # var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "kv_subnet" {
  count                = !var.public_network_access_enabled && var.allow_access_from ? 1 : 0
  name                 = local.kv_subnet_name # Replace with your Subnet name
  virtual_network_name = data.azurerm_virtual_network.kv_vnet[0].name
  resource_group_name  = var.resource_group_name_public_access #data.azurerm_virtual_network.kv_vnet.resource_group_name
}


# Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "pv_vnet" {
  count               = !var.allow_access_from ? 1 : 0
  name                = local.pv_vnet_name                       # Replace with your VNet name
  resource_group_name = var.resource_group_name_private_endpoint # ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "pv_subnet" {
  count                = !var.allow_access_from ? 1 : 0
  name                 = local.pv_subnet_name # Replace with your Subnet name
  virtual_network_name = data.azurerm_virtual_network.pv_vnet[0].name
  resource_group_name  = var.resource_group_name_private_endpoint #data.azurerm_virtual_network.pv_vnet.resource_group_name
}
