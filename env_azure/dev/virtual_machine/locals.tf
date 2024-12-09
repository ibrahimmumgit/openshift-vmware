 
locals {
 
  effective_environment_map = {
    "UAT"  = "4"
    "DEV"  = "5"
    "PROD" = "1"
  }
 
    effective_application_type = {
    "WEB"  = "wb"
    "APP"  = "ap"
    "DB" = "db"
  }
 
  subnet_cidr      = data.azurerm_subnet.vm_subnet.address_prefix
  private_ip_address = cidrhost(data.azurerm_subnet.vm_subnet.address_prefixes[0], var.host_offset_in_subnet)
 
  vm_names     = var.create_new_resource_group ? [] : [for vm in data.azurerm_resources.vm[0].resources : vm.name]
  apptype      = var.applicationtype
 
# Filter VM names that contain the specified apptype and end with two digits
  filtered_vm_names = [
    for name in local.vm_names :
    name if can(regex(".*(?i)${local.effective_application_type[local.apptype]}[0-9]{2}$", name)) # Matches names that contain 'APP' or any apptype and end with two digits
  ]
 
  # Extract numeric suffixes from the filtered VM names (e.g., 'ptazsg4vmeapp01' => '01')
  vm_suffixes = [
    for name in local.filtered_vm_names :
    tonumber(regex("([0-9]{2})$", name)[0])  # Extract the numeric part from the VM name
    if can(regex("([0-9]{2})$", name))    # Ensure the regex match was successful
  ]
 
  # Sort the numeric suffixes to determine the next available number
  sorted_vm_suffixes = sort(local.vm_suffixes)
 
  # Determine the next VM number (if no VMs exist with the specified apptype, start from 1)
  next_vm_number = length(local.sorted_vm_suffixes) > 0 ? local.sorted_vm_suffixes[length(local.sorted_vm_suffixes) - 1] + 1 : 1
 
  #next_vm_name = format("%s%02d", local.next_vm_number)
  next_vm_name = format("%02d", local.next_vm_number)
 
 
 
 
  ###
  # The single object_id to validate
  object_id_tf     = data.azurerm_client_config.current.object_id
  user_identity_id = var.create_new_identity_access ? [azurerm_user_assigned_identity.uai[0].principal_id] : length(data.azurerm_user_assigned_identity.uai) > 0 ? [data.azurerm_user_assigned_identity.uai[0].principal_id] : []
 
  # Retrieve the list of existing object_ids from Key Vault's access policies
  existing_object_id        = var.key_vault_name != null && var.key_vault_name != "" ? [for policy in data.azurerm_key_vault.vault[0].access_policy : policy.object_id] : []
  existing_user_identity_id = var.identity_name == null && var.identity_name != "" ? [] : length(data.azurerm_user_assigned_identity.uai) > 0 ? [for policy in data.azurerm_key_vault.vault[0].access_policy : policy.object_id] : []
 
  # Check if the new object_id exists in the list of existing object_ids
  object_id_exists_tf     = contains(local.existing_object_id, local.object_id_tf)
  user_identity_id_exists = contains(local.existing_user_identity_id, local.user_identity_id)
 
  // split_values_network_kv = split(" - ", var.vm_vnet_network_name)
  // vm_vnet_name            = length(local.split_values_network_kv) > 0 ? local.split_values_network_kv[0] : ""
  // vm_subnet_name          = length(local.split_values_network_kv) > 1 ? local.split_values_network_kv[1] : ""
 
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
