locals {


  storage_account_names = var.create_new_resource_group ? [] : [for account in data.azurerm_resources.storage_account[0].resources : account.name]

  # Extract numeric suffixes from storage account names that contain the specified string
  storage_account_suffixes = [
    for name in local.storage_account_names :
    tonumber(regex("[0-9]+$", name))
    if can(regex("[0-9]+$", name))
  ]

  # Sort the numeric suffixes to determine the next account number
  sorted_storage_account_suffixes = sort(local.storage_account_suffixes)

  # Determine the next storage account number
  next_storage_account_number = length(local.sorted_storage_account_suffixes) > 0 ? local.sorted_storage_account_suffixes[length(local.sorted_storage_account_suffixes) - 1] + 1 : 1

  # Generate the initial new storage account name
  unique_storage_account_name = format("%02d", local.next_storage_account_number)

  # Create a unique name by incrementing if the name already exists
  next_storage_account_name = local.unique_storage_account_name



  // user_identity_id = !var.data_encryption_type && var.identity_access && var.create_new_identity_access ? [azurerm_user_assigned_identity.uai[0].principal_id] : length(data.azurerm_user_assigned_identity.uai) > 0 ? [data.azurerm_user_assigned_identity.uai[0].principal_id] : []
  // # Retrieve the list of existing object_ids from Key Vault's access policies
  // existing_object_ids       = var.key_vault_name != null && var.key_vault_name != "" ? [for policy in data.azurerm_key_vault.vault[0].access_policy : policy.object_id] : []
  // existing_object_id        = var.key_vault_name != null && var.key_vault_name != "" ? [for policy in data.azurerm_key_vault.vault[0].access_policy : policy.object_id] : []
  // existing_user_identity_id = var.identity_name == null && var.identity_name != "" ? [] : length(data.azurerm_user_assigned_identity.uai) > 0 ? [for policy in data.azurerm_key_vault.vault[0].access_policy : policy.object_id] : []
  // # Check if the new object_id exists in the list of existing object_ids

  // object_id_exists_tf     = contains(local.existing_object_id, local.object_id_tf)
  // user_identity_id_exists = contains(local.existing_user_identity_id, local.user_identity_id)

  # Only split if network_access_enabled is true, otherwise return an empty list
  split_values_network_kv = var.public_network_access_enabled && !var.allow_access_from ? split(" - ", var.public_network_access_enabled_network_name) : []

  # Assign VNet and Subnet names only if network access is enabled
  sa_vnet_name   = var.public_network_access_enabled && !var.allow_access_from && length(local.split_values_network_kv) > 0 ? local.split_values_network_kv[0] : ""
  sa_subnet_name = var.public_network_access_enabled && !var.allow_access_from && length(local.split_values_network_kv) > 1 ? local.split_values_network_kv[1] : ""

  # Only split if network_access_enabled is true, otherwise return an empty list
  split_values_network_pv = !var.public_network_access_enabled && !var.allow_access_from  ? split(" - ", var.private_endpoint_network_name) : []

  # Assign VNet and Subnet names only if network access is enabled
  pv_vnet_name   = !var.public_network_access_enabled && !var.allow_access_from && length(local.split_values_network_pv) > 0 ? local.split_values_network_pv[0] : ""
  pv_subnet_name = !var.public_network_access_enabled && !var.allow_access_from && length(local.split_values_network_pv) > 1 ? local.split_values_network_pv[1] : ""



  parts                     = !var.create_new_resource_group && var.resource_group_name != null ? split("-", var.resource_group_name) : []
  environment               = !var.create_new_resource_group && var.resource_group_name != null ? local.parts[2] : ""
  applicationname           = !var.create_new_resource_group && var.resource_group_name != null ? lower(local.parts[3]) : ""
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