
locals {
  vm_names = var.create_new_resource_group ? [] : [for vm in data.azurerm_resources.vm[0].resources : vm.name]

  # Extract numeric suffixes from vm names that contain the specified string
  vm_suffixes = [
    for name in local.vm_names :
    tonumber(regex("[0-9]+$", name))
    if can(regex("[0-9]+$", name))
  ]

  # Sort the numeric suffixes to determine the next account number
  sorted_vm_suffixes = sort(local.vm_suffixes)

  # Determine the next storage account number
  next_vm_number = length(local.sorted_vm_suffixes) > 0 ? local.sorted_vm_suffixes[length(local.sorted_vm_suffixes) - 1] + 1 : 1

  # Generate the initial new storage account name
  next_vm_name = format("%02d", local.next_vm_number)




  split_values_network_kv = split(" - ", var.vm_vnet_network_name)
  vm_vnet_name            = length(local.split_values_network_kv) > 0 ? local.split_values_network_kv[0] : ""
  vm_subnet_name          = length(local.split_values_network_kv) > 1 ? local.split_values_network_kv[1] : ""

  ######################################################
  parts           = !var.create_new_resource_group && var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment     = !var.create_new_resource_group && var.resource_group_name != null ? local.parts[2] : ""
  applicationname = !var.create_new_resource_group && var.resource_group_name != null ? lower(local.parts[3]) : ""
  # parts                     = var.resource_group_name != null ? split("-", var.resource_group_name) : []
  # environment               = var.resource_group_name != null ? local.parts[2] : ""
  # applicationname           = var.resource_group_name != null ? lower(local.parts[3]) : ""
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location

  common_rg_tags = var.create_new_resource_group ? {
    appid            = var.appid
    appsupport       = var.appsupport
    criticality      = var.criticality
    disasterrecovery = var.disasterrecovery
    rpo              = var.rpo
    rto              = var.rto
    sla              = var.sla
    description      = var.description
  } : data.azurerm_resource_group.rg[0].tags

  common_vm_tags = {
    appname       = var.appname
    businessowner = var.businessowner
    businessunit  = var.businessunit
    costcenter    = var.costcenter
    environment   = var.environment
    projectname   = var.projectname
    requestedby   = var.requestedby
  }
}