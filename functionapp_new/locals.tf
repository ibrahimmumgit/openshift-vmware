locals {
  #define the sku size which is required the app_service_environment_id
  sku_isolated_size         = ["B1", "B2", "B3", "S1", "S2", "S3"]
  parts                     = var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.resource_group_name != null ? lower(local.parts[3]) : ""
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location

  service_plan_name = [for sp in data.azurerm_resources.app_service_plans.resources : sp.name]



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

  # Handle case where no Windows App Service Plans are found
  windows_increment              = var.linux_funcapp_count == 0 ? 0 : 1
  windows_app_service_plan_ids   = local.ewindows_plan_len > 0 ? local.eapp_windows_service_plan_ids[0] : var.windows_funcapp_count == 0 ? "" : azurerm_service_plan.aspwindows[0].id
  windows_app_service_plan_names = local.ewindows_plan_len > 0 ? [local.ewindows_app_service_plan_names[0]] : var.windows_funcapp_count == 0 ? [] : [(format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}asp" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}asp" : "5${local.effective_applicationname}asp", local.windows_increment + local.elinux_plan_len + 1))]
  # Handle case where no Linux App Service Plans are found
  linux_app_service_plan_ids   = local.elinux_plan_len > 0 ? local.eapp_linux_service_plan_ids[0] : var.linux_funcapp_count == 0 ? "" : azurerm_service_plan.asplinux[0].id
  linux_app_service_plan_names = local.elinux_plan_len > 0 ? [local.elinux_app_service_plan_names[0]] : var.linux_funcapp_count == 0 ? [] : [(format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}asp" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}asp" : "5${local.effective_applicationname}asp", local.ewindows_plan_len + 1))]

  # Find the Max number for functionapp
  existing_total_azure_funcapp_count     = length(data.azurerm_resources.existing_funcapps.resources)
  existing_funcapps_resource_numbers_str = length(data.azurerm_resources.existing_funcapps.resources) > 0 ? [for res in data.azurerm_resources.existing_funcapps.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_funcapps_resource_numbers     = length(data.azurerm_resources.existing_funcapps.resources) > 0 ? [for num_str in local.existing_funcapps_resource_numbers_str : tonumber(num_str)] : []

  # Max resource number, defaulting to 0 if not applicable
  existing_funcapps_max_resource_numbers = length(local.existing_funcapps_resource_numbers) > 0 ? max(local.existing_funcapps_resource_numbers...) : 0


  # Check if the file exists and read it
  linux_function_app_names_from_file = fileexists("${path.module}/linux_function_app_names.txt") ? split("\n", file("${path.module}/linux_function_app_names.txt")) : []

  # Get the length of the array
  linux_function_app_names_count_from_file = length(local.linux_function_app_names_from_file)

  # Generate new function app names if needed
  nlinux_funcapp_names = local.linux_function_app_names_count_from_file < var.linux_funcapp_count ? [for i in range(var.linux_funcapp_count - local.linux_function_app_names_count_from_file) : (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}func" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}func" : "5${local.effective_applicationname}func", local.existing_funcapps_max_resource_numbers + i + 1))] : []

  # Concatenate old names with new names
  linux_funcapp_names = concat(local.linux_function_app_names_from_file, local.nlinux_funcapp_names)

  # Slice the list to keep only the first 'desired_count' items
  truncated_linux_funcapp_names = slice(local.linux_funcapp_names, 0, var.linux_funcapp_count)


  # serviceplan_check
  linux_serviceplan_names_from_file = fileexists("${path.module}/linux_function_app_serviceplan.txt") ? split("\n", file("${path.module}/linux_function_app_serviceplan.txt")) : []

  # Get the length of the array
  linux_serviceplan_names_from_file_length = length(local.linux_serviceplan_names_from_file)


  # serviceplan_check
  windows_serviceplan_names_from_file = fileexists("${path.module}/windows_function_app_serviceplan.txt") ? split("\n", file("${path.module}/windows_function_app_serviceplan.txt")) : []

  # Get the length of the array
  windows_serviceplan_names_from_file_length = length(local.windows_serviceplan_names_from_file)




  # Check if the file exists and read it
  windows_function_app_names_from_file = fileexists("${path.module}/windows_function_app_names.txt") ? split("\n", file("${path.module}/windows_function_app_names.txt")) : []

  # Get the length of the array
  windows_function_app_names_count_from_file = length(local.windows_function_app_names_from_file)

  # Generate new function app names if needed
  nwindows_funcapp_names = local.windows_function_app_names_count_from_file < var.windows_funcapp_count ? [for i in range(var.windows_funcapp_count - local.windows_function_app_names_count_from_file) : (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}func" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}func" : "5${local.effective_applicationname}func", local.existing_funcapps_max_resource_numbers + var.linux_funcapp_count + i + 1))] : []

  # Concatenate old names with new names
  windows_funcapp_names = concat(local.windows_function_app_names_from_file, local.nwindows_funcapp_names)

  # Slice the list to keep only the first 'desired_count' items
  truncated_windows_funcapp_names = slice(local.windows_funcapp_names, 0, var.windows_funcapp_count)



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
    SRNumber              = var.srnumber
  }

}



