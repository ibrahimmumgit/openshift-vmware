# Azure Load Balancer
module "azlb" {
  source                = "./module/azurerm_lb"
  azlb_name             = (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}lb" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}lb" : "5${local.effective_applicationname}lb", local.existing_lb_max_resource_numbers + 1))
  azlb_rg_name          = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  zlb_location_name     = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  edge_zone             = " "
  lb_sku                = "Standard"
  lb_sku_tier           = "Regional"
  tags                  = local.common_tags
  ########## Front End (FE01) Details
  frontend_count = var.frontend_count
  frontend_name1 = "fe01"
  subnet_id1 = var.is_public == false ? data.azurerm_subnet.lb_subnet.id : null
  private_ip_address_allocation1 = var.is_public == false ? "Dynamic" : null
  private_ip_address_version1 = var.is_public == false ? "IPv4" : null
  public_ip_address_id1 = var.is_public == true ? data.azurerm_public_ip.pubip01[0].id : null
  ########## Front End (FE02) Details
  frontend_name2 = var.frontend_count == 2 ? "fe02" : null
  subnet_id2 = var.is_public == false && var.frontend_count == 2 ? data.azurerm_subnet.lb_subnet.id : null
  private_ip_address_allocation2 = var.is_public == false && var.frontend_count == 2 ? "Dynamic" : null
  private_ip_address_version2 = var.is_public == false && var.frontend_count == 2 ? "IPv4" : null
  public_ip_address_id2 = var.is_public == true && var.frontend_count == 2 ? data.azurerm_public_ip.pubip02[0].id : null
}

############################# backend_address_pool, NIC Association, Probe, LB Rules for FE01 ##########################
# backend_address_pool (FE01-BE01)
module "fe01_be01" {
  source                        = "./module/azurerm_lb_backend_address_pool"
  count                         = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 ? 1 : 0
  azlb_id                       = module.azlb.id
  backend_address_pool_name     = "fe01_be01"
  backend_address_pool_syncmode = "Automatic"
  azlb_vnet_id                  = data.azurerm_virtual_network.lb_vnet.id
}
# NIC Association - (FE01-BE01-VM01)
module "fe01_be01_nic_association_01" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 && var.fe01_be01_vm_count >= 1 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe01_be01_vm01_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe01_be01_vm01_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe01_be01[0].id
}
# NIC Association - (FE01-BE01-VM02)
module "fe01_be01_nic_association_02" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 && var.fe01_be01_vm_count >= 2 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe01_be01_vm02_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe01_be01_vm02_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe01_be01[0].id
}
# PROBE - (FE01-BE01-PROBE)
module "fe01_be01_probe" {
  source                    = "./module/azurerm_lb_probe"
  count                     = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 ? 1 : 0
  probe_name                = "fe01_be01_probe"
  azlb_id                   = module.azlb.id
  probe_protocol            = var.fe01_be01_probe_protocol
  probe_port                = var.fe01_be01_probe_port
  request_path              =  var.fe01_be01_probe_protocol == "Http" || var.fe01_be01_probe_protocol == "Https" ?  var.fe01_be01_probe_request_path : null
  probe_threshold           = var.fe01_be01_probe_threshold
  interval_in_seconds       = var.fe01_be01_probe_interval_in_seconds
  number_of_probes          = var.fe01_be01_probe_number_of_probes
}
# LB RULE - (FE01-BE01-PROBE-RULE)
module "fe01_be01_rule" {
  source                            = "./module/azurerm_lb_rule"
  count                             = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 1 ? 1 : 0
  azlb_rule_name                    = "fe01_be01_rule"
  azlb_id                           = module.azlb.id
  frontend_ip_configuration_name    = module.azlb.frontend_ip_configuration[0].name
  azlb_rule_protocol                = var.fe01_be01_rule_protocol
  azlb_rule_frontend_port           = var.fe01_be01_rule_frontend_port
  azlb_rule_backend_port            = var.fe01_be01_rule_backend_port
  backend_address_pool_ids          = [module.fe01_be01[0].id]
  probe_id                          = module.fe01_be01_probe[0].id
  enable_floating_ip                = var.fe01_be01_rule_enable_floating_ip
  idle_timeout_in_minutes           = var.fe01_be01_rule_idle_timeout_in_minutes
  load_distribution                 = var.fe01_be01_rule_load_distribution
  disable_outbound_snat             = var.fe01_be01_rule_disable_outbound_snat
  enable_tcp_reset                  = var.fe01_be01_rule_enable_tcp_reset
}
# backend_address_pool (FE01-BE02)
module "fe01_be02" {
  source                        = "./module/azurerm_lb_backend_address_pool"
  count                         = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 ? 1 : 0
  azlb_id                       = module.azlb.id
  backend_address_pool_name     = "fe01_be02"
  backend_address_pool_syncmode = "Automatic"
  azlb_vnet_id                  = data.azurerm_virtual_network.lb_vnet.id
}
# NIC Association - (FE01-BE02-VM01)
module "fe01_be02_nic_association_01" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 && var.fe01_be02_vm_count >= 1 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe01_be02_vm01_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe01_be02_vm01_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe01_be02[0].id
}
# NIC Association - (FE01-BE02-VM02)
module "fe01_be02_nic_association_02" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 && var.fe01_be02_vm_count >= 2 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe01_be02_vm02_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe01_be02_vm02_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe01_be02[0].id
}
# PROBE - (FE01-BE02-PROBE)
module "fe01_be02_probe" {
  source                    = "./module/azurerm_lb_probe"
  count                     = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 ? 1 : 0
  probe_name                = "fe01_be02_probe"
  azlb_id                   = module.azlb.id
  probe_protocol            = var.fe01_be02_probe_protocol
  probe_port                = var.fe01_be02_probe_port
  request_path              =  var.fe01_be02_probe_protocol == "Http" || var.fe01_be02_probe_protocol == "Https" ?  var.fe01_be02_probe_request_path : null
  probe_threshold           = var.fe01_be02_probe_threshold
  interval_in_seconds       = var.fe01_be02_probe_interval_in_seconds
  number_of_probes          = var.fe01_be02_probe_number_of_probes
}
# LB RULE - (FE01-BE02-PROBE-RULE)
module "fe01_be02_rule" {
  source                            = "./module/azurerm_lb_rule"
  count                             = var.frontend_count >= 1 && var.fe01_backend_address_pool_count >= 2 ? 1 : 0
  azlb_rule_name                    = "fe01_be02_rule"
  azlb_id                           = module.azlb.id
  frontend_ip_configuration_name    = module.azlb.frontend_ip_configuration[0].name
  azlb_rule_protocol                = var.fe01_be02_rule_protocol
  azlb_rule_frontend_port           = var.fe01_be02_rule_frontend_port
  azlb_rule_backend_port            = var.fe01_be02_rule_backend_port
  backend_address_pool_ids          = [module.fe01_be02[0].id]
  probe_id                          = module.fe01_be02_probe[0].id
  enable_floating_ip                = var.fe01_be02_rule_enable_floating_ip
  idle_timeout_in_minutes           = var.fe01_be02_rule_idle_timeout_in_minutes
  load_distribution                 = var.fe01_be02_rule_load_distribution
  disable_outbound_snat             = var.fe01_be02_rule_disable_outbound_snat
  enable_tcp_reset                  = var.fe01_be02_rule_enable_tcp_reset
}

####################################  backend_address_pool, NIC Association, Probe, LB Rules for FE02 ##########################
# backend_address_pool (FE02-BE01)
module "fe02_be01" {
  source                        = "./module/azurerm_lb_backend_address_pool"
  count                         = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 ? 1 : 0
  azlb_id                       = module.azlb.id
  backend_address_pool_name     = "fe02_be01"
  backend_address_pool_syncmode = "Automatic"
  azlb_vnet_id                  = data.azurerm_virtual_network.lb_vnet.id
}
# NIC Association - (fe02-BE01-VM01)
module "fe02_be01_nic_association_01" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 && var.fe02_be01_vm_count >= 1 ? 1 : 0 
  network_interface_id      = data.azurerm_network_interface.fe02_be01_vm01_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe02_be01_vm01_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe02_be01[0].id
}
# NIC Association - (fe02-BE01-VM02)
module "fe02_be01_nic_association_02" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 && var.fe02_be01_vm_count >= 2 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe02_be01_vm02_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe02_be01_vm02_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe02_be01[0].id
}
# PROBE - (fe02-BE01-PROBE)
module "fe02_be01_probe" {
  source                    = "./module/azurerm_lb_probe"
  count                     = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 ? 1 : 0
  probe_name                = "fe02_be01_probe"
  azlb_id                   = module.azlb.id
  probe_protocol            = var.fe02_be01_probe_protocol
  probe_port                = var.fe02_be01_probe_port
  request_path              =  var.fe02_be01_probe_protocol == "Http" || var.fe02_be01_probe_protocol == "Https" ?  var.fe02_be01_probe_request_path : null
  probe_threshold           = var.fe02_be01_probe_threshold
  interval_in_seconds       = var.fe02_be01_probe_interval_in_seconds
  number_of_probes          = var.fe02_be01_probe_number_of_probes
}
# LB RULE - (fe02-BE01-PROBE-RULE)
module "fe02_be01_rule" {
  source                            = "./module/azurerm_lb_rule"
  count                             = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 1 ? 1 : 0
  azlb_rule_name                    = "fe02_be01_rule"
  azlb_id                           = module.azlb.id
  frontend_ip_configuration_name    = module.azlb.frontend_ip_configuration[1].name
  azlb_rule_protocol                = var.fe02_be01_rule_protocol
  azlb_rule_frontend_port           = var.fe02_be01_rule_frontend_port
  azlb_rule_backend_port            = var.fe02_be01_rule_backend_port
  backend_address_pool_ids          = [module.fe02_be01[0].id]
  probe_id                          = module.fe02_be01_probe[0].id
  enable_floating_ip                = var.fe02_be01_rule_enable_floating_ip
  idle_timeout_in_minutes           = var.fe02_be01_rule_idle_timeout_in_minutes
  load_distribution                 = var.fe02_be01_rule_load_distribution
  disable_outbound_snat             = var.fe02_be01_rule_disable_outbound_snat
  enable_tcp_reset                  = var.fe02_be01_rule_enable_tcp_reset
}
# backend_address_pool (fe02-BE02)
module "fe02_be02" {
  source                        = "./module/azurerm_lb_backend_address_pool"
  count                         = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 ? 1 : 0
  azlb_id                       = module.azlb.id
  backend_address_pool_name     = "fe02_be02"
  backend_address_pool_syncmode = "Automatic"
  azlb_vnet_id                  = data.azurerm_virtual_network.lb_vnet.id
}
# NIC Association - (fe02-BE02-VM01)
module "fe02_be02_nic_association_01" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 && var.fe02_be02_vm_count >= 1 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe02_be02_vm01_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe02_be02_vm01_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe02_be02[0].id
}
# NIC Association - (fe02-BE02-VM02)
module "fe02_be02_nic_association_02" {
  source                    = "./module/azurerm_network_interface_backend_address_pool_association"
  count                     = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 && var.fe02_be02_vm_count >= 2 ? 1 : 0
  network_interface_id      = data.azurerm_network_interface.fe02_be02_vm02_nic[0].id
  ip_configuration_name     = data.azurerm_network_interface.fe02_be02_vm02_nic[0].ip_configuration[0].name
  backend_address_pool_id   = module.fe02_be02[0].id
}
# PROBE - (fe02-BE02-PROBE)
module "fe02_be02_probe" {
  source                    = "./module/azurerm_lb_probe"
  count                     = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 ? 1 : 0
  probe_name                = "fe02_be02_probe"
  azlb_id                   = module.azlb.id
  probe_protocol            = var.fe02_be02_probe_protocol
  probe_port                = var.fe02_be02_probe_port
  request_path              =  var.fe02_be02_probe_protocol == "Http" || var.fe02_be02_probe_protocol == "Https" ?  var.fe02_be02_probe_request_path : null
  probe_threshold           = var.fe02_be02_probe_threshold
  interval_in_seconds       = var.fe02_be02_probe_interval_in_seconds
  number_of_probes          = var.fe02_be02_probe_number_of_probes
}
# LB RULE - (fe02-BE02-PROBE-RULE)
module "fe02_be02_rule" {
  source                            = "./module/azurerm_lb_rule"
  count                             = var.frontend_count >= 2 && var.fe02_backend_address_pool_count >= 2 ? 1 : 0
  azlb_rule_name                    = "fe02_be02_rule"
  azlb_id                           = module.azlb.id
  frontend_ip_configuration_name    = module.azlb.frontend_ip_configuration[1].name
  azlb_rule_protocol                = var.fe02_be02_rule_protocol
  azlb_rule_frontend_port           = var.fe02_be02_rule_frontend_port
  azlb_rule_backend_port            = var.fe02_be02_rule_backend_port
  backend_address_pool_ids          = [module.fe02_be02[0].id]
  probe_id                          = module.fe02_be02_probe[0].id
  enable_floating_ip                = var.fe02_be02_rule_enable_floating_ip
  idle_timeout_in_minutes           = var.fe02_be02_rule_idle_timeout_in_minutes
  load_distribution                 = var.fe02_be02_rule_load_distribution
  disable_outbound_snat             = var.fe02_be02_rule_disable_outbound_snat
  enable_tcp_reset                  = var.fe02_be02_rule_enable_tcp_reset
}
###############################################################
# Application Insights creation (conditionally created based on enable_monitoring and create_new_application_insigts variables)
resource "azurerm_log_analytics_workspace" "alaw" {
  count               = var.enable_monitoring && var.create_new_application_insigts ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-log" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-log" : "-5${local.effective_applicationname}-log"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = var.alaw_sku
  retention_in_days   = 30
  tags                = local.common_tags
}
resource "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring && var.create_new_application_insigts ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-appins" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-appins" : "-5${local.effective_applicationname}-appins"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  workspace_id        = azurerm_log_analytics_workspace.alaw[0].id
  application_type    = "other"
  tags                = local.common_tags
}
resource "azurerm_monitor_diagnostic_setting" "logds" {
  count               = var.enable_monitoring && var.create_new_application_insigts ? 1 : 0
  name               = "diagnostic_setting01"
  target_resource_id = module.azlb.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.alaw[0].id
  metric {
      category = "AllMetrics"
  }
  enabled_log {
    category_group = "allLogs"
  }
}
/*
############################ Manages a Load Balancer Outbound Rule ######################################
# Use outbound rules to configure the outbound network address translation (NAT) for all virtual machines in the backend pool.
# To create an outbound rule, the load balancer SKU must be standard and the frontend IP configuration must have at least one public IP address.
module "outbound_rule_01" {
  source                    = "./module/azurerm_lb_outbound_rule"
  count                     = var.backend_address_pool_count >= 1 ? 1 : 0
  is_public                 = var.is_public
  outbound_rule_name        = "outbound_rule_01"
  loadbalancer_id           = module.azlb.id
  frontend_name             = module.azlb.frontend_ip_configuration[0].name
  backend_address_pool_id   = module.backend_address_pool_01[0].id
  protocol                  = "Tcp"
  enable_tcp_reset          = true
  allocated_outbound_ports  = 1024
  idle_timeout_in_minutes   = 4
}


module "outbound_rule_02" {
  source                    = "./module/azurerm_lb_outbound_rule"
  count                     = var.backend_address_pool_count >= 2 ? 1 : 0
  is_public                 = var.is_public
  outbound_rule_name        = "outbound_rule_02"
  loadbalancer_id           = module.azlb.id
  frontend_name             = module.azlb.frontend_ip_configuration[0].name
  backend_address_pool_id   = module.backend_address_pool_02[0].id
  protocol                  = "Tcp"
  enable_tcp_reset          = true
  allocated_outbound_ports  = 1024
  idle_timeout_in_minutes   = 4
}

############################ Manages a Load Balancer Inbound NAT Rule ######################################
module "inbound_nat_rule_01" {
  source                    = "./module/azurerm_lb_nat_rule"
  count                     = var.backend_address_pool_count >= 1 ? 1 : 0
  nat_rule_name             = "inbound_nat_rule_01"
  resource_group_name       = module.azlb.resource_group_name
  loadbalancer_id           = module.azlb.id
  frontend_name             = module.azlb.frontend_ip_configuration[0].name
  protocol                  = "Tcp"
  frontend_port             = var.inbound_nat_rule_01_frontend_port
  backend_port              = 80
  backend_address_pool_id   = var.inbound_nat_rule_01_frontend_port != null ? null : module.backend_address_pool_01[0].id
  frontend_port_start       = var.inbound_nat_rule_01_frontend_port != null ? null : 3000
  frontend_port_end         = var.inbound_nat_rule_01_frontend_port != null ? null : 3008
  idle_timeout_in_minutes   = 4
  enable_floating_ip        = false
  enable_tcp_reset          = false
}
*/