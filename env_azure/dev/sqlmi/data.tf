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

# Fetch existing SQL Managed Instances in the resource group
data "azurerm_resources" "sqlmi" { 
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filters to find only SQL Managed Instances
  type = "Microsoft.Sql/managedInstances"
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


data "azurerm_key_vault" "vault" {
  count               =  var.key_vault_name != null && var.key_vault_name !="" ? 1 : 0
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  name                = var.key_vault_name # Specify the name of your existing Key Vault
}


# # Data source for the key in the Key Vault
# data "azurerm_key_vault_key" "vault_key" {
#   count        = var.key_name != null && var.key_name != "" ? 1 : 0
#   name         = var.key_name # Specify the name of the key you want to retrieve
#   key_vault_id = data.azurerm_key_vault.vault[0].id
# }

# # Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "sql_vnet" {
  name                = local.sql_vnet_name                
  resource_group_name = var.resource_group_name_sql_vnet 
}
 
# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "sql_subnet" {
  name                 = local.sql_subnet_name 
  virtual_network_name = data.azurerm_virtual_network.sql_vnet.name
  resource_group_name  = var.resource_group_name_sql_vnet 
}