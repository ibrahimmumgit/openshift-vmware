locals {
  parts                     = var.create_new_resource_group ? [] : var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.create_new_resource_group ? "" : var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.create_new_resource_group ? "" : var.resource_group_name != null ? lower(local.parts[3]) : ""
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location

# Fetch vnet and subnet id for agw
  split_values_network_agw = split(" - ", var.agw_vnet_network_details)
  agw_vnet_name           = length(local.split_values_network_agw) > 0 ? local.split_values_network_agw[0] : ""
  agw_subnet_name         = length(local.split_values_network_agw) > 1 ? local.split_values_network_agw[1] : ""
  
  # Find the Max number for agw
  existing_agw_resource_numbers_str = length(data.azurerm_resources.agw.resources) > 0 ? [for res in data.azurerm_resources.agw.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_agw_resource_numbers     = length(data.azurerm_resources.agw.resources) > 0 ? [for num_str in local.existing_agw_resource_numbers_str : tonumber(num_str)] : []
  # Max resource number, defaulting to 0 if not applicable
  existing_agw_max_resource_numbers = length(local.existing_agw_resource_numbers) > 0 ? max(local.existing_agw_resource_numbers...) : 0

  # Find the Max number for publicip
  existing_pubip_resource_numbers_str = length(data.azurerm_resources.pubip.resources) > 0 ? [for res in data.azurerm_resources.pubip.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_pubip_resource_numbers     = length(data.azurerm_resources.pubip.resources) > 0 ? [for num_str in local.existing_pubip_resource_numbers_str : tonumber(num_str)] : []
  # Max resource number, defaulting to 0 if not applicable
  existing_pubip_max_resource_numbers = length(local.existing_pubip_resource_numbers) > 0 ? max(local.existing_pubip_resource_numbers...) : 0

# Construct Tags
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