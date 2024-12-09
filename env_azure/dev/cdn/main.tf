#Terraform code to create CDN profile 
resource "azurerm_cdn_profile" "profile" {
  count               = var.create_new_profile ? 1 : 0
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}pf${local.next_cdn_profile_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}pf${local.next_cdn_profile_name}" : "-5${local.effective_applicationname}pf${local.next_cdn_profile_name}"}")
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_type
  tags                = local.common_tags
  lifecycle {
       ignore_changes = [name]
  }
}

resource "azurerm_cdn_endpoint" "endpoint" {
  count               = var.endpoint_setting ? 1 : 0  # Create the endpoint only if enabled
  name                = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}cdn${local.next_cdn_endpoint_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}cdn${local.next_cdn_endpoint_name}" : "-5${local.effective_applicationname}cdn${local.next_cdn_endpoint_name}"}")
  resource_group_name = var.resource_group_name
  location            = var.location
  profile_name        = var.create_new_profile ? azurerm_cdn_profile.profile[0].name : var.profile_name
  tags                = local.common_tags
  origin_host_header = var.origin_type == "storage" ? data.azurerm_storage_account.existing[0].primary_web_host : var.origin_type == "linux_function_app" ? data.azurerm_linux_function_app.linux_function_app[0].default_hostname : var.origin_type == "linux_web_app" ? data.azurerm_linux_web_app.linux_web_app[0].default_hostname : var.origin_type == "windows_web_app" ? data.azurerm_windows_web_app.windows_web_app[0].default_hostname : var.origin_type == "windows_function_app" ? data.azurerm_windows_function_app.windows_function_app[0].default_hostname : var.host_name


  origin {
    name              = lower("ptazsg${var.environment == "PROD" ? "-1${local.effective_applicationname}origin${local.next_cdn_endpoint_name}" : var.environment == "UAT" ? "-4${local.effective_applicationname}origin${local.next_cdn_endpoint_name}" : "-5${local.effective_applicationname}origin${local.next_cdn_endpoint_name}"}")
    host_name         = var.origin_type == "storage" ? data.azurerm_storage_account.existing[0].primary_web_host : var.origin_type == "linux_function_app" ? data.azurerm_linux_function_app.linux_function_app[0].default_hostname : var.origin_type == "linux_web_app" ? data.azurerm_linux_web_app.linux_web_app[0].default_hostname : var.origin_type == "windows_web_app" ? data.azurerm_windows_web_app.windows_web_app[0].default_hostname : var.origin_type == "windows_function_app" ? data.azurerm_windows_function_app.windows_function_app[0].default_hostname : var.host_name

  }
  lifecycle {
    ignore_changes = [
      name,                            
      origin             
    ]
  }
  # Configure query string caching behavior
  querystring_caching_behaviour = var.query_string_caching_behavior
}
