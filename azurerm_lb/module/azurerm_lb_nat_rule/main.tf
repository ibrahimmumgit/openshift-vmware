# Manages a Load Balancer NAT Rule.
/*
resource "azurerm_lb_nat_rule" "azlb" {
  name                   = var.nat_rule_name
  resource_group_name = var.resource_group_name
  loadbalancer_id    = var.loadbalancer_id
  frontend_ip_configuration_name = var.frontend_name
  protocol                    = var.protocol
  frontend_port = var.frontend_port
  backend_port = var.backend_port
  frontend_port_start = var.frontend_port_start
  frontend_port_end = var.frontend_port_end
  backend_address_pool_id = var.backend_address_pool_id
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  enable_floating_ip = var.enable_floating_ip
  enable_tcp_reset = var.enable_tcp_reset
}
*/