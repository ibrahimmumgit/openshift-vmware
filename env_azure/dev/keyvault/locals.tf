locals {



  # Fetch the names of existing vault names
  key_vault_names = var.create_new_resource_group ? [] : [for vault in data.azurerm_resources.keyvault[0].resources : vault.name]

  # Extract the numeric suffix from vault names like "kv-01"
  key_vault_suffixes = [
    for name in local.key_vault_names : 
    tonumber(regex("[0-9]+$", name)) 
    if can(regex("[0-9]+$", name))
  ]

  # Sort the numeric suffixes to determine the next vault number
  sorted_key_vault_suffixes = sort(local.key_vault_suffixes)

  # If there are existing instances, increment the highest number, else start with 1
  next_key_vault_number = length(local.sorted_key_vault_suffixes) > 0 ? local.sorted_key_vault_suffixes[length(local.sorted_key_vault_suffixes) - 1] + 1 : 1

  # Format the new instance name as "sqlmi-XX"
  next_key_vault_name = format("%02d", local.next_key_vault_number)
}


locals {

  parts                     = var.create_new_resource_group ? [] : var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = var.create_new_resource_group ? "" : var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = var.create_new_resource_group ? "" : var.resource_group_name != null ? lower(local.parts[3]) : ""  
  effective_environment     = var.create_new_resource_group ? var.environment : local.environment
  effective_applicationname = var.create_new_resource_group ? var.applicationname : local.applicationname
  effective_locaion         = var.create_new_resource_group ? var.location : data.azurerm_resource_group.rg[0].location
  
  env_prefix = lookup({ PROD = "1", UAT = "4", DEV = "5" }, local.effective_environment)
  prefix     = lower("${var.rg_prefix}-${local.env_prefix}${local.effective_applicationname}")


  # Only split if network_access_enabled is true, otherwise return an empty list
  split_values_network_kv = var.public_network_access_enabled && var.allow_access_from ? split(" - ", var.public_network_access_enabled_network_name) : []
  
  # Assign VNet and Subnet names only if network access is enabled
  kv_vnet_name    = var.public_network_access_enabled && length(local.split_values_network_kv) > 0 ? local.split_values_network_kv[0] : ""
  kv_subnet_name  = var.public_network_access_enabled && length(local.split_values_network_kv) > 1 ? local.split_values_network_kv[1] : ""

    # Only split if network_access_enabled is true, otherwise return an empty list
  split_values_network_pv = var.private_endpoint ? split(" - ", var.private_endpoint_network_name) : []
  
  # Assign VNet and Subnet names only if network access is enabled
  pv_vnet_name    = var.private_endpoint && length(local.split_values_network_pv) > 0 ? local.split_values_network_pv[0] : ""
  pv_subnet_name  = var.private_endpoint && length(local.split_values_network_pv) > 1 ? local.split_values_network_pv[1] : ""



  basic_key_permissions = [
    "Get", 
    "List"
  ]

  intermediate_key_permissions = concat(
    local.basic_key_permissions, 
    ["Encrypt", "Decrypt", "WrapKey", "UnwrapKey"]
  )

  advanced_key_permissions = concat(
    local.intermediate_key_permissions,
    ["Sign", "Verify", "Backup", "Restore", "Purge", "Delete", "Update", "Create", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  )

  selected_key_permissions = var.key_permissions_level == "advanced" ? local.advanced_key_permissions : var.key_permissions_level == "intermediate" ? local.intermediate_key_permissions : local.basic_key_permissions 

# Basic secret permissions
  basic_secret_permissions = [
    "Get", 
    "List"
  ]

  # Intermediate secret permissions (adds to basic)
  intermediate_secret_permissions = concat(
    local.basic_secret_permissions,
    ["Set", "Delete"]
  )

  # Advanced secret permissions (adds to intermediate)
  advanced_secret_permissions = concat(
    local.intermediate_secret_permissions,
    ["Backup", "Restore", "Purge", "Recover"]
  )

  # Selected secret permissions based on input
  selected_secret_permissions = var.secret_permissions_level == "advanced" ? local.advanced_secret_permissions : var.secret_permissions_level == "intermediate" ? local.intermediate_secret_permissions : local.basic_secret_permissions


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



