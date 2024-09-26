locals {
  #define the sku size which is required the app_service_environment_id
  sku_isolated_size         = ["B1", "B2", "B3", "S1", "S2", "S3"]
  parts                     = var.create_new_resource_group ? [] : split("-", var.resource_group_name)
  environment               = var.create_new_resource_group ? "" : local.parts[2]
  applicationname           = var.create_new_resource_group ? "" : lower(local.parts[3])
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location

  service_plan_name    = [for sp in data.azurerm_resources.app_service_plans.resources : sp.name]
  storage_account_name = [for sp in data.azurerm_resources.storage_aacount.resources : sp.name]

  #Extract Linux service Plan names
  elinux_app_service_plan_names = [for sp in data.azurerm_service_plan.details : sp.name if sp.kind == "linux"]
  elinux_plan_len               = length(local.elinux_app_service_plan_names)
  # Extract IDs of the filtered App Service Plans
  eapp_linux_service_plan_ids = [for sp in data.azurerm_service_plan.details : sp.id if sp.kind == "linux"]

  #Extract Windows service Plan names
  ewindows_app_service_plan_names = [for sp in data.azurerm_service_plan.details : sp.name if sp.kind != "linux"]
  ewindows_plan_len               = length(local.ewindows_app_service_plan_names)
  # Extract IDs of the filtered App Service Plans
  eapp_windows_service_plan_ids = [for sp in data.azurerm_service_plan.details : sp.id if sp.kind != "linux"]

  #Extract the stroage account details
  estorage_name = [for sp in data.azurerm_storage_account.details : sp.name]
  estorage_len  = length(local.estorage_name)
  estorage_ids  = [for sp in data.azurerm_storage_account.details : sp.id]

  # Handle case where no Windows App Service Plans are found
  windows_increment              = var.create_new_resource_group && var.linux_webapp_count == 0 ? 0 : 1
  windows_app_service_plan_ids   = local.ewindows_plan_len > 0 ? local.eapp_windows_service_plan_ids[0] : var.windows_webapp_count == 0 ? "" : azurerm_service_plan.aspwindows[0].id
  windows_app_service_plan_names = local.ewindows_plan_len > 0 ? [local.ewindows_app_service_plan_names[0]] : var.windows_webapp_count == 0 ? [] : local.windows_serviceplan_names_from_file_length == 0 ? [(format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}asp" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}asp" : "5${local.effective_applicationname}asp", local.windows_increment + local.elinux_plan_len + 1))]: local.windows_serviceplan_names_from_file
  
  # Handle case where no Linux App Service Plans are found
  linux_increment = var.create_new_resource_group ? local.windows_serviceplan_names_from_file_length : local.ewindows_plan_len
  linux_app_service_plan_ids   = local.elinux_plan_len > 0 ? local.eapp_linux_service_plan_ids[0] : var.linux_webapp_count != 0 ? azurerm_service_plan.asplinux[0].id : ""
  linux_app_service_plan_names = local.elinux_plan_len > 0 ? [local.elinux_app_service_plan_names[0]] : var.linux_webapp_count == 0 ? [] : local.linux_serviceplan_names_from_file_length == 0 ? [(format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}asp" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}asp" : "5${local.effective_applicationname}asp", local.linux_increment + 1))] : local.linux_serviceplan_names_from_file 

  # Find the Max number for webapp
  existing_total_azure_webapp_count     = length(data.azurerm_resources.existing_webapps.resources)
  existing_webapps_resource_numbers_str = length(data.azurerm_resources.existing_webapps.resources) > 0 ? [for res in data.azurerm_resources.existing_webapps.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_webapps_resource_numbers     = length(data.azurerm_resources.existing_webapps.resources) > 0 ? [for num_str in local.existing_webapps_resource_numbers_str : tonumber(num_str)] : []

  # Max resource number, defaulting to 0 if not applicable
  existing_webapps_max_resource_numbers = length(local.existing_webapps_resource_numbers) > 0 ? max(local.existing_webapps_resource_numbers...) : 0



  # Find the Max number for webapp post linux
  update_existing_total_azure_webapp_count     = length(data.azurerm_resources.updated_function_apps.resources)
  update_existing_webapps_resource_numbers_str = length(data.azurerm_resources.updated_function_apps.resources) > 0 ? [for res in data.azurerm_resources.updated_function_apps.resources : regexall("[0-9]+$", res.name)[0]] : []
  update_existing_webapps_resource_numbers     = length(data.azurerm_resources.updated_function_apps.resources) > 0 ? [for num_str in local.update_existing_webapps_resource_numbers_str : tonumber(num_str)] : []

  # Max resource number, defaulting to 0 if not applicable
  update_existing_webapps_max_resource_numbers = length(local.update_existing_webapps_resource_numbers) > 0 ? max(local.update_existing_webapps_resource_numbers...) : 0



  # Check if the file exists and read it
  linux_web_app_names_from_file = fileexists("${path.module}/linux_web_app_names.txt") ? split("\n", file("${path.module}/linux_web_app_names.txt")) : []

  # Get the length of the array
  linux_web_app_names_count_from_file = length(local.linux_web_app_names_from_file)

  # Generate new web app names if needed
  nlinux_webapp_names = local.linux_web_app_names_count_from_file < var.linux_webapp_count ? [for i in range(var.linux_webapp_count - local.linux_web_app_names_count_from_file) : (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}wb" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}wb" : "5${local.effective_applicationname}wb", local.existing_webapps_max_resource_numbers + i + 1))] : []

  # Concatenate old names with new names
  linux_webapp_names = concat(local.linux_web_app_names_from_file, local.nlinux_webapp_names)

  # Slice the list to keep only the first 'desired_count' items
  truncated_linux_webapp_names = slice(local.linux_webapp_names, 0, var.linux_webapp_count)

  # serviceplan_check
  linux_serviceplan_names_from_file = fileexists("${path.module}/linux_web_app_serviceplan.txt") ? split("\n", file("${path.module}/linux_web_app_serviceplan.txt")) : []
  # Split the content of the file into a list of lines (if the file has content)
  linux_valid_serviceplan_names     = compact(local.linux_serviceplan_names_from_file)
  # Get the count of valid service plan names
  linux_serviceplan_names_from_file_length     = length(local.linux_valid_serviceplan_names)



  # serviceplan_check
  windows_serviceplan_names_from_file = fileexists("${path.module}/windows_web_app_serviceplan.txt") ? split("\n", file("${path.module}/windows_web_app_serviceplan.txt")) : []
  # Get the length of the array
  windows_valid_serviceplan_names     = compact(local.windows_serviceplan_names_from_file)
  windows_serviceplan_names_from_file_length     = length(local.windows_valid_serviceplan_names)






  # Check if the file exists and read it
  windows_web_app_names_from_file = fileexists("${path.module}/windows_web_app_names.txt") ? split("\n", file("${path.module}/windows_web_app_names.txt")) : []

  # Get the length of the array
  windows_web_app_names_count_from_file = length(local.windows_web_app_names_from_file)

  # Generate new web app names if needed
  nwindows_webapp_names = local.windows_web_app_names_count_from_file < var.windows_webapp_count ? [for i in range(var.windows_webapp_count - local.windows_web_app_names_count_from_file) : (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}wb" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}wb" : "5${local.effective_applicationname}wb", local.update_existing_webapps_max_resource_numbers  + i + 1))] : []

  # Concatenate old names with new names
  windows_webapp_names = concat(local.windows_web_app_names_from_file, local.nwindows_webapp_names)

  # Generate backup names if needed
  linux_webapp_backup_names   = [for name in local.linux_webapp_names : (length(regexall("wb\\d{2}$", name)) > 0 ? ("${substr(name, 0, length(name) - length(regexall("wb\\d{2}$", name)[0]))}bkp${substr(name, length(name) - 2, 2)}") : name)]
  windows_webapp_backup_names = [for name in local.windows_webapp_names : (length(regexall("wb\\d{2}$", name)) > 0 ? ("${substr(name, 0, length(name) - length(regexall("wb\\d{2}$", name)[0]))}bkp${substr(name, length(name) - 2, 2)}") : name)]

  # Slice the list to keep only the first 'desired_count' items
  truncated_windows_webapp_names = slice(local.windows_webapp_names, 0, var.windows_webapp_count)



  common_tags = {
    Project_Code          = var.project_code
    ApplicationId         = var.applicationid
    ApplicationName       = local.effective_applicationname
    environment           = local.effective_environment
    CostCenter            = var.costcenter
    DataClassification    = var.dataclassification
    SCAClassification     = var.scaclassification
    IACRepo               = var.iacrepo
    ProductOwner          = var.productowner
    ProductSupport        = var.productsupport
    BusinessOwner         = var.businessowner
    CSBIA_Availability    = var.csbia_availability
    CSBIA_Confidentiality = var.csbia_confidentiality
    CSBIA_Impactscore     = var.csbia_impactscore
    CSBIA_Integrity       = var.csbia_integrity
    BusinessOPU_HCU       = var.businessopu_hcu
    BusinessStream        = var.businessstream
  }

}