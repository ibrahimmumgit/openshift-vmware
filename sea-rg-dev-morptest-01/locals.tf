locals {
  nsgrules = {

    AllowOnPremInBound_SSH = {
      name                       = "AllowOnPremInBound_SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = null
      source_address_prefixes    = ["192.168.66.0/24", "192.168.24.0/24", "192.168.32.0/24", "192.168.129.21", "192.168.129.22"]
      destination_address_prefix = "*"
    }
  }

  nsgrules2 = {

    AllowOnPremInBound_SSH = {
      name                       = "AllowOnPremInBound_SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = null
      source_address_prefixes    = ["192.168.66.0/24", "192.168.24.0/24", "192.168.32.0/24", "192.168.129.21", "192.168.129.22"]
      destination_address_prefix = "*"
    }
  }

    nsgrules3 = {

    AllowOnPremInBound_RDP = {
      name                       = "AllowOnPremInBound_RDP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = null
      source_address_prefixes    = ["192.168.66.0/24", "192.168.24.0/24", "192.168.32.0/24", "192.168.129.21", "192.168.129.22"]
      destination_address_prefix = "*"
    }
  }
}