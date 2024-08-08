#Create the linux function app if service plan os_type is linux
resource "azurerm_linux_function_app" "funcapp_linux" {
  count                      = var.linux_funcapp_count
  name                       = lower(format("ptazsg-%s%02d", var.environment == "PROD" ? "1${var.projectname}func" : var.environment == "UAT" ? "4${var.projectname}func" : "5${var.projectname}func", count.index + 1))
  resource_group_name        = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                   = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id            = var.app_service_plan == "separate" ? azurerm_service_plan.asplinux[count.index].id : azurerm_service_plan.asplinux[0].id
  storage_account_name       = var.create_storage_account == true ? azurerm_storage_account.asa[0].name : data.azurerm_storage_account.asa[0].name
  storage_account_access_key = var.create_storage_account == true ? azurerm_storage_account.asa[0].primary_access_key : data.azurerm_storage_account.asa[0].primary_access_key
  https_only                 = true
  enabled                    = true

  site_config {
    minimum_tls_version                    = "1.2"
    application_insights_connection_string = var.enable_monitoring == true ? (var.application_insights_name == null ? (length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].connection_string : null) : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].connection_string : null)) : null
    application_insights_key               = var.enable_monitoring == true ? (var.application_insights_name == null ? (length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].instrumentation_key : null) : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].instrumentation_key : null)) : null
    application_stack {
      java_version            = var.runtime_stack_linux == "java" ? var.runtime_version_linux : null
      dotnet_version          = var.runtime_stack_linux == "dotnet" ? var.runtime_version_linux : null
      node_version            = var.runtime_stack_linux == "node" ? var.runtime_version_linux : null
      python_version          = var.runtime_stack_linux == "python" ? var.runtime_version_linux : null
      powershell_core_version = var.runtime_stack_linux == "powershell" ? var.runtime_version_linux : null
    }

  }

  tags = {
    environment = var.environment
    project     = var.projectname
  }
}

#Create the windows function app if service plan os_type is windows
resource "azurerm_windows_function_app" "funcapp_windows" {
  count                      = var.windows_funcapp_count
  name                       = lower(format("ptazsg-%s%02d", var.environment == "PROD" ? "1${var.projectname}func" : var.environment == "UAT" ? "4${var.projectname}func" : "5${var.projectname}func", var.linux_funcapp_count + count.index + 1))
  resource_group_name        = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location                   = var.create_new_resource_group == true ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  service_plan_id            = var.app_service_plan == "separate" ? azurerm_service_plan.aspwindows[count.index].id : azurerm_service_plan.aspwindows[0].id
  storage_account_name       = var.create_storage_account == true ? azurerm_storage_account.asa[0].name : data.azurerm_storage_account.asa[0].name
  storage_account_access_key = var.create_storage_account == true ? azurerm_storage_account.asa[0].primary_access_key : data.azurerm_storage_account.asa[0].primary_access_key
  https_only                 = true
  enabled                    = true

  site_config {
    minimum_tls_version                    = "1.2"
    application_insights_connection_string = var.enable_monitoring == true ? (var.application_insights_name == null ? (length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].connection_string : null) : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].connection_string : null)) : null
    application_insights_key               = var.enable_monitoring == true ? (var.application_insights_name == null ? (length(azurerm_application_insights.aai) > 0 ? azurerm_application_insights.aai[0].instrumentation_key : null) : (length(data.azurerm_application_insights.aai) > 0 ? data.azurerm_application_insights.aai[0].instrumentation_key : null)) : null
    application_stack {
      java_version   = var.runtime_stack_windows == "java" ? var.runtime_version_windows : null
      dotnet_version = var.runtime_stack_windows == "dotnet" ? var.runtime_version_windows : null
      node_version   = var.runtime_stack_windows == "node" ? var.runtime_version_windows : null
      #python_version          = var.runtime_stack_windows == "python" ? var.runtime_version_windows : null
      powershell_core_version = var.runtime_stack_windows == "powershell" ? var.runtime_version_windows : null
    }
  }
  tags = {
    environment = var.environment
    project     = var.projectname
  }
}