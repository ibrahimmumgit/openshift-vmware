locals {
  #define the sku size which is required the app_service_environment_id
  sku_isolated_size         = ["B1", "B2", "B3", "S1", "S2", "S3"]
  parts                     = var.create_new_resource_group ? [] : var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.create_new_resource_group ? "" : var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.create_new_resource_group ? "" : var.resource_group_name != null ? lower(local.parts[3]) : ""  
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location
  funcappname = "${var.rg_prefix}-${local.effective_environment == "PROD" ? "1${local.effective_applicationname}func" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}func" : "5${local.effective_applicationname}func"}"

  # Regex pattern to match the funcappname
  funcappname_pattern = "(?i)${local.funcappname}" # Case insensitive pattern

  # Find the Max number for service plan
  service_plan_name                          = [for sp in data.azurerm_resources.app_service_plans.resources : sp.name]
  existing_total_azure_serviceplan_count     = length(data.azurerm_resources.app_service_plans.resources)
  existing_serviceplans_resource_numbers_str = length(data.azurerm_resources.app_service_plans.resources) > 0 ? [for res in data.azurerm_resources.app_service_plans.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_serviceplans_resource_numbers     = length(data.azurerm_resources.app_service_plans.resources) > 0 ? [for num_str in local.existing_serviceplans_resource_numbers_str : tonumber(num_str)] : []

  # Max resource number, defaulting to 0 if not applicable
  existing_serviceplans_max_resource_numbers = length(local.existing_serviceplans_resource_numbers) > 0 ? max(local.existing_serviceplans_resource_numbers...) : 0


  # Filter Function Apps based on name containing 'func' (case insensitive)
  filtered_function_apps = [for res in data.azurerm_resources.existing_funcapps.resources : res if can(regex(local.funcappname_pattern, res.name))]

  # Extract numerical suffix from Function App names
  existing_funcapps_resource_numbers_str = length(local.filtered_function_apps) > 0 ? [for res in local.filtered_function_apps : regexall("[0-9]+$", res.name)[0]] : []
  existing_funcapps_resource_numbers = length(local.existing_funcapps_resource_numbers_str) > 0 ? [for num_str in local.existing_funcapps_resource_numbers_str : tonumber(num_str)] : []
  existing_funcapps_max_resource_numbers = length(local.existing_funcapps_resource_numbers) > 0 ? max(local.existing_funcapps_resource_numbers...) : 0
  

  # Check if the file exists and read it
  windows_function_app_names_from_file = fileexists("${path.module}/windows_function_app_names.txt") ? split("\n", file("${path.module}/windows_function_app_names.txt")) : []

  # Get the length of the array
  windows_function_app_names_count_from_file = length(local.windows_function_app_names_from_file)

  # Generate new function app names if needed
  nwindows_funcapp_names = local.windows_function_app_names_count_from_file < var.windows_funcapp_count ? [for i in range(var.windows_funcapp_count - local.windows_function_app_names_count_from_file) : "${local.funcappname}${format("%02d", local.existing_funcapps_max_resource_numbers + i + 1)}"] : []

  # Concatenate old names with new names
  windows_funcapp_names = concat(local.windows_function_app_names_from_file, local.nwindows_funcapp_names)

  # Slice the list to keep only the first 'desired_count' items
  truncated_windows_funcapp_names = slice(local.windows_funcapp_names, 0, var.windows_funcapp_count)






  common_tags = var.create_new_resource_group ? {
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
    SRNumber              = var.srnumber
  } : data.azurerm_resource_group.rg[0].tags
}



