
locals {


  # Find the Max number for service plan
  profile_name                          = [for sp in data.azurerm_resources.cdn_profiles.resources : sp.name]
  existing_total_azure_profile_count     = length(data.azurerm_resources.cdn_profiles.resources)
  existing_profiles_resource_numbers_str = length(data.azurerm_resources.cdn_profiles.resources) > 0 ? [for res in data.azurerm_resources.cdn_profiles.resources : regexall("[0-9]+$", res.name)[0]] : []
  existing_profiles_resource_numbers     = length(data.azurerm_resources.cdn_profiles.resources) > 0 ? [for num_str in local.existing_profiles_resource_numbers_str : tonumber(num_str)] : []

  # Max resource number, defaulting to 0 if not applicable
  existing_profiles_max_resource_numbers = length(local.existing_profiles_resource_numbers) > 0 ? max(local.existing_profiles_resource_numbers...) : 0


  # Generate the next CDN profile name
  next_cdn_profile_name = format("%02d", local.existing_profiles_max_resource_numbers + 1)

# Extract names using list comprehension
  # Example endpoint names retrieved from your data source
  endpoint_names = [for endpoint in data.azurerm_resources.cdn_endpoints.resources : endpoint.name]
 
  # Extract numeric suffixes from the endpoint names
  existing_endpoints_numbers_flat = [
    for name in local.endpoint_names : 
    regex(".*?(\\d+)$", name) != null ? tonumber(regex(".*?(\\d+)$", name)[0]) : null
  ]

  # Filter out null values to create a flat list of numbers
  filtered_existing_endpoint_numbers = [
    for num in local.existing_endpoints_numbers_flat : num if num != null
  ]

  # Calculate the max from the filtered numbers, defaulting to 0 if the list is empty
  existing_endpoint_max_resource_numbers = length(local.filtered_existing_endpoint_numbers) > 0 ? max(local.filtered_existing_endpoint_numbers...) : 0



  # Generate the next CDN endpoint name
  next_cdn_endpoint_name = format("%02d", local.existing_endpoint_max_resource_numbers + 1)


 

   parts                     = split("-", var.resource_group_name)
   environment               = local.parts[2]
   applicationname           = lower(local.parts[3])
   effective_environment     = local.environment
   effective_applicationname = local.applicationname
   effective_locaion         = data.azurerm_resource_group.rg.location

   common_tags               = data.azurerm_resource_group.rg.tags 
}