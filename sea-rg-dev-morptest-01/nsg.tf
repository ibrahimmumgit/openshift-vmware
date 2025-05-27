# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

resource "azurerm_network_security_group" "KIBBAZDINFRA01-nsg" {
  name                = "KIBBAZDINFRA01-nsg"
  location            = azurerm_resource_group.sea-rg-dev-morptest-01.location
  resource_group_name = azurerm_resource_group.sea-rg-dev-morptest-01.name

  #tags = var.resources_tags
}

resource "azurerm_network_security_rule" "KIBBAZDINFRA01-nsg-rules" {
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  source_address_prefixes     = each.value.source_address_prefixes
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.sea-rg-dev-morptest-01.name
  network_security_group_name = azurerm_network_security_group.KIBBAZDINFRA01-nsg.name
}

# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

# resource "azurerm_network_interface_security_group_association" "KIBBAZDINFRA01-nsg-ass" {
#   network_interface_id      = azurerm_network_interface.KIBBAZDINFRA01.id
#   network_security_group_id = azurerm_network_security_group.KIBBAZDINFRA01-nsg.id
# }

# ############################################################################################################################################
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

# resource "azurerm_network_security_group" "KIBBAZDINFRA02-nsg" {
#   name                = "KIBBAZDINFRA02-nsg"
#   location            = azurerm_resource_group.sea-rg-dev-morptest-01.location
#   resource_group_name = azurerm_resource_group.sea-rg-dev-morptest-01.name

#   #tags = var.resources_tags
# }

# resource "azurerm_network_security_rule" "KIBBAZDINFRA02-nsg-rules" {
#   for_each                    = local.nsgrules2
#   name                        = each.key
#   direction                   = each.value.direction
#   access                      = each.value.access
#   priority                    = each.value.priority
#   protocol                    = each.value.protocol
#   source_port_range           = each.value.source_port_range
#   destination_port_range      = each.value.destination_port_range
#   source_address_prefix       = each.value.source_address_prefix
#   source_address_prefixes     = each.value.source_address_prefixes
#   destination_address_prefix  = each.value.destination_address_prefix
#   resource_group_name         = azurerm_resource_group.sea-rg-dev-morptest-01.name
#   network_security_group_name = azurerm_network_security_group.KIBBAZDINFRA02-nsg.name
# }

#   # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

# resource "azurerm_network_interface_security_group_association" "KIBBAZDINFRA02-nsg-ass" {
#   network_interface_id      = azurerm_network_interface.KIBBAZDINFRA02.id
#   network_security_group_id = azurerm_network_security_group.KIBBAZDINFRA02-nsg.id
# }

# ############################################################################################################################################
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

# resource "azurerm_network_security_group" "KIBBAZDINFRA03-nsg" {
#   name                = "KIBBAZDINFRA03-nsg"
#   location            = azurerm_resource_group.sea-rg-dev-morptest-01.location
#   resource_group_name = azurerm_resource_group.sea-rg-dev-morptest-01.name

#   #tags = var.resources_tags
# }

# resource "azurerm_network_security_rule" "KIBBAZDINFRA03-nsg-rules" {
#   for_each                    = local.nsgrules3
#   name                        = each.key
#   direction                   = each.value.direction
#   access                      = each.value.access
#   priority                    = each.value.priority
#   protocol                    = each.value.protocol
#   source_port_range           = each.value.source_port_range
#   destination_port_range      = each.value.destination_port_range
#   source_address_prefix       = each.value.source_address_prefix
#   source_address_prefixes     = each.value.source_address_prefixes
#   destination_address_prefix  = each.value.destination_address_prefix
#   resource_group_name         = azurerm_resource_group.sea-rg-dev-morptest-01.name
#   network_security_group_name = azurerm_network_security_group.KIBBAZDINFRA03-nsg.name
# }

#   # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

# resource "azurerm_network_interface_security_group_association" "KIBBAZDINFRA03-nsg-ass" {
#   network_interface_id      = azurerm_network_interface.KIBBAZDINFRA03.id
#   network_security_group_id = azurerm_network_security_group.KIBBAZDINFRA03-nsg.id
# }