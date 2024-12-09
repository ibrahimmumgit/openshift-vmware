locals {
  # Fetch the names of existing SQL Managed Instances
  sql_mi_names = var.create_new_resource_group ? [] : [for instance in data.azurerm_resources.sqlmi[0].resources : instance.name]

  # Extract the numeric suffix from instance names like "sqlmi-01"
  sql_mi_suffixes = [
    for name in local.sql_mi_names : 
    tonumber(regex("[0-9]+$", name)) 
    if can(regex("[0-9]+$", name))
  ]

  # Sort the numeric suffixes to determine the next instance number
  sorted_sql_mi_suffixes = sort(local.sql_mi_suffixes)

  # If there are existing instances, increment the highest number, else start with 1
  next_sql_mi_number = length(local.sorted_sql_mi_suffixes) > 0 ? local.sorted_sql_mi_suffixes[length(local.sorted_sql_mi_suffixes) - 1] + 1 : 1

  # Format the new instance name as "sqlmi-XX"
  next_sql_mi_name = format("sqlmi%02d", local.next_sql_mi_number)
	
  split_values_network_kv =  split(" - ", var.sql_vnet_network_name)

  sql_vnet_name   = length(local.split_values_network_kv) > 0 ? local.split_values_network_kv[0] : ""
  sql_subnet_name = length(local.split_values_network_kv) > 1 ? local.split_values_network_kv[1] : ""
}


locals {
  parts                     = var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.resource_group_name != null ? lower(local.parts[3]) : ""
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location

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
  } : data.azurerm_resource_group.rg[0].tags
} 