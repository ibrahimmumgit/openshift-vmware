locals {
  #define the sku size which is required the app_service_environment_id
  sku_isolated_size         = ["B1", "B2", "B3", "S1", "S2", "S3"]
  parts                     = var.create_new_resource_group ? [] : var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.create_new_resource_group ? "" : var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.create_new_resource_group ? "" : var.resource_group_name != null ? lower(local.parts[3]) : ""
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location
  webappname = "${var.rg_prefix}-${local.effective_environment == "PROD" ? "1${local.effective_applicationname}web" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}web" : "5${local.effective_applicationname}web"}"

  # Regex pattern to match the webappname
  webappname_pattern = "(?i)${local.webappname}" # Case insensitive pattern

  # Find the Max number for service plan
  service_plan_name                          = [for sp in data.azurerm_resources.app_service_plans.resources : sp.name]
  existing_total_azure_serviceplan_count     = length(data.azurerm_resources.app_service_plans.resources)
  existing_serviceplans_resource_numbers_str = length(data.azurerm_resources.app_service_plans.resources) > 0 ? [for res in data.azurerm_resources.app_service_plans.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_serviceplans_resource_numbers     = length(data.azurerm_resources.app_service_plans.resources) > 0 ? [for num_str in local.existing_serviceplans_resource_numbers_str : tonumber(num_str)] : []

  # Max resource number, defaulting to 0 if not applicable
  existing_serviceplans_max_resource_numbers = length(local.existing_serviceplans_resource_numbers) > 0 ? max(local.existing_serviceplans_resource_numbers...) : 0


  # Filter web Apps based on name containing 'web' (case insensitive)
  filtered_web_apps = [for res in data.azurerm_resources.existing_webapps.resources : res if can(regex(local.webappname_pattern, res.name))]

  # Extract numerical suffix from web App names
  existing_webapps_resource_numbers_str = length(local.filtered_web_apps) > 0 ? [for res in local.filtered_web_apps : regexall("[0-9]+$", res.name)[0]] : []
  existing_webapps_resource_numbers = length(local.existing_webapps_resource_numbers_str) > 0 ? [for num_str in local.existing_webapps_resource_numbers_str : tonumber(num_str)] : []
  existing_webapps_max_resource_numbers = length(local.existing_webapps_resource_numbers) > 0 ? max(local.existing_webapps_resource_numbers...) : 0
  

  # Check if the file exists and read it
  linux_web_app_names_from_file = fileexists("${path.module}/linux_web_app_names.txt") ? split("\n", file("${path.module}/linux_web_app_names.txt")) : []

  # Get the length of the array
  linux_web_app_names_count_from_file = length(local.linux_web_app_names_from_file)

  # Generate new web app names if needed
  nlinux_webapp_names = local.linux_web_app_names_count_from_file < var.linux_webapp_count ? [for i in range(var.linux_webapp_count - local.linux_web_app_names_count_from_file) : "${local.webappname}${format("%02d", local.existing_webapps_max_resource_numbers + i + 1)}"] : []

  # Concatenate old names with new names
  linux_webapp_names = concat(local.linux_web_app_names_from_file, local.nlinux_webapp_names)

  # Slice the list to keep only the first 'desired_count' items
  truncated_linux_webapp_names = slice(local.linux_webapp_names, 0, var.linux_webapp_count)


 linux_webapp_backup_names   = [for name in local.linux_webapp_names : (length(regexall("wb\\d{2}$", name)) > 0 ? ("${substr(name, 0, length(name) - length(regexall("wb\\d{2}$", name)[0]))}bkp${substr(name, length(name) - 2, 2)}") : name)]





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
    #SRNumber              = var.srnumber
  } : data.azurerm_resource_group.rg[0].tags
}



