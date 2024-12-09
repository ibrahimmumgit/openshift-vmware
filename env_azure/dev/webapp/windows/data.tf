# Data source for existing resource group (used when create_new_resource_group is false)
data "azurerm_resource_group" "rg" {
  count = var.create_new_resource_group ? 0 : 1
  name  = var.resource_group_name
}


# Data source to fetch all resources in a specific resource group
data "azurerm_resources" "existing_webapps" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filter to get only resources of type Microsoft.Web/sites
  type = "Microsoft.Web/sites"
}

# Data source to fetch serviceplan  in a specific resource group
data "azurerm_resources" "app_service_plans" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filter to get only resources of type Microsoft.Web/serverfarms
  type = "Microsoft.Web/serverfarms"
}

data "azurerm_service_plan" "details" {
  count               = var.create_new_service_plan ? 0 : 1
  name                = var.serviceplan_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

# Data source to fetch storage account in a specific resource group
data "azurerm_resources" "storage_aacount" {
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  # Filter to get only resources of type Microsoft.Web/serverfarms
  type = "Microsoft.Storage/storageAccounts"
}

# Data source to read all resources
data "azurerm_resources" "all" {
  count               = var.create_new_resource_group ? 0 : 1
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}






# Data source to read the windows web app names from the file
data "local_file" "fwindows_web_app_names_from_file" {
  count    = fileexists("windows_web_app_names.txt") ? 1 : 0
  filename = "${path.module}/windows_web_app_names.txt"
}

data "azurerm_user_assigned_identity" "uai" {
  count               = var.create_new_identity_access || var.identity_access == "SystemAssigned" ? 0 : 1
  name                = var.identity_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

# Data source for existing Application Insights instance (used when create_new_application_insigts is false)
data "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring && var.create_new_application_insigts != true ? 1 : 0
  name                = var.application_insights_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}


# Data source for existing storage account (used when create_storage_account is false)
data "azurerm_storage_account" "asa" {
  count               = var.backup_enable && !var.create_storage_account  ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}


# Data source for existing storage container 
data "azurerm_storage_container" "asc" {
  count                = var.backup_enable && !var.create_storage_account && !var.create_container ? 1 : 0
  #count = 0
  #name                 = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "1${local.effective_applicationname}bkpcn" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}bkpcn" : "5${local.effective_applicationname}bkpcn"}")
  name                 = var.container_name
  storage_account_name = var.storage_account_name
}

data "azurerm_storage_account_sas" "asas" {
  count        = var.backup_enable ? 1 : 0
  connection_string = var.create_storage_account ? azurerm_storage_account.asa[0].primary_connection_string : data.azurerm_storage_account.asa[0].primary_connection_string 
  #container_name    = var.backup_enable && var.create_new_resource_group ? azurerm_storage_container.asc[0].name : local.estorage_len == 0 && var.backup_enable ? azurerm_storage_container.asc[0].name : local.estorage_len > 0 ? data.azurerm_storage_container.asc[0].name : 0
  https_only = true
  start      = timestamp()                   # Current date and time
  expiry     = timeadd(timestamp(), "8765h") # 1 year from now (8765 hours)
  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  permissions {
    read    = false
    write   = true
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
  depends_on = [
    azurerm_storage_container.asc
  ]
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



