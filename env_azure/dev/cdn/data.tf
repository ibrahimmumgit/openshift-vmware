# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  name  = var.resource_group_name
}

# Data source to read all resources
data "azurerm_resources" "all" {
  resource_group_name = var.resource_group_name
}


# Data resource to fetch all CDN profiles in the resource group
data "azurerm_resources" "cdn_profiles" {
  resource_group_name = var.resource_group_name

  # Filters to find only CDN profiles
  type = "Microsoft.Cdn/profiles"
}

data "azurerm_resources" "cdn_endpoints" {
  resource_group_name = var.resource_group_name

  # Filters to find only CDN profiles
  type = "Microsoft.Cdn/profiles/endpoints"
}






# Data source to retrieve the client configuration
data "azurerm_client_config" "current" {}


# data "azuread_group" "group" {
#   count        = var.create_new_resource_group ? 1 : 0
#   display_name = var.role_access
# }

# data "azurerm_role_definition" "custom" {
#   count = var.create_new_resource_group && var.custom_role_name != null ? 1 : 0
#   name  = var.custom_role_name
#   scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
# }

# Data source to reference existing Storage Account
data "azurerm_storage_account" "existing" {
  count               = var.origin_type == "storage" ? 1 : 0
  name                = var.host_name
  resource_group_name = var.resource_group_name
}

# Data source for existing function Web App
data "azurerm_windows_web_app" "windows_web_app" {
  count               = var.origin_type == "windows_web_app" ? 1 : 0
  name                = var.host_name
  resource_group_name = var.resource_group_name
}

# Data source for existing linux Web App
data "azurerm_linux_function_app" "linux_function_app" {
  count               = var.origin_type == "linux_function_app" ? 1 : 0
  name                = var.host_name
  resource_group_name = var.resource_group_name
}

# Data source for existing linux Web App
data "azurerm_linux_web_app" "linux_web_app" {
  count               = var.origin_type == "linux_web_app" ? 1 : 0
  name                = var.host_name
  resource_group_name = var.resource_group_name
}

#Data source for exitsing Fucntion App
data "azurerm_windows_function_app" "windows_function_app" {
  count               = var.origin_type == "windows_function_app" ? 1 : 0
  name                = var.host_name
  resource_group_name = var.resource_group_name
}


