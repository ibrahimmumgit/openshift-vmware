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

data "azurerm_resources" "vm" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filters to find only vms
  type = "Microsoft.Compute/virtualMachines"
}

# Fetch existing Key Vaults
data "azurerm_resources" "keyvault" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filters to find only Key Vaults
  type = "Microsoft.KeyVault/vaults"
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

#
# Data source for the key in the Key Vault
data "azurerm_key_vault_key" "vault_key" {
  count        = var.key_name != null && var.key_name != "" ? 1 : 0
  name         = var.key_name # Specify the name of the key you want to retrieve
  key_vault_id = data.azurerm_key_vault.vault[0].id
}

#network
# # Data source to get the Virtual Network by its name
data "azurerm_virtual_network" "vm_vnet" {
  name                = local.vm_vnet_name
  resource_group_name = var.resource_group_name_vm_vnet
}

# Data source to get the Subnet by its name in the Virtual Network
data "azurerm_subnet" "vm_subnet" {
  name                 = local.vm_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.name
  resource_group_name  = var.resource_group_name_vm_vnet
}