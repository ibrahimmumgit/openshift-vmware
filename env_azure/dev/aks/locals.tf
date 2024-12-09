locals {
  aks_names = var.create_new_resource_group ? [] : [for instance in data.azurerm_resources.aks[0].resources : instance.name]


  aks_suffixes = [
    for name in local.aks_names :
    tonumber(regex("[0-9]+$", name))
    if can(regex("[0-9]+$", name))
  ]

  # Sort the numeric suffixes to determine the next instance number
  sorted_aks_suffixes = sort(local.aks_suffixes)

  # If there are existing instances, increment the highest number, else start with 1
  next_aks_number = length(local.sorted_aks_suffixes) > 0 ? local.sorted_aks_suffixes[length(local.sorted_aks_suffixes) - 1] + 1 : 1

  next_aks_name     = format("akscls%02d", local.next_aks_number)
  next_aksnode_name = format("node%02d", local.next_aks_number)


  split_values_network_kv = split(" - ", var.aks_vnet_network_name)
  aks_vnet_name           = length(local.split_values_network_kv) > 0 ? local.split_values_network_kv[0] : ""
  aks_subnet_name         = length(local.split_values_network_kv) > 1 ? local.split_values_network_kv[1] : ""




  parts                     = var.create_new_resource_group ? [] : var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.create_new_resource_group ? "" : var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.create_new_resource_group ? "" : var.resource_group_name != null ? lower(local.parts[3]) : ""
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
    #SRNumber              = var.srnumber
  } : data.azurerm_resource_group.rg[0].tags
}