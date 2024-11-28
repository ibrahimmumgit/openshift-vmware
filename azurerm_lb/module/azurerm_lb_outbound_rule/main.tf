/*
# Manages a Load Balancer Outbound Rule.
resource "azurerm_lb_outbound_rule" "azlb" {
  count = var.is_public ? 1 : 0
  name                   = var.outbound_rule_name
  loadbalancer_id    = var.loadbalancer_id
  backend_address_pool_id              = var.backend_address_pool_id
  protocol                    = var.protocol
  enable_tcp_reset                = var.enable_tcp_reset
  allocated_outbound_ports                   = var.allocated_outbound_ports
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
    frontend_ip_configuration    {
      name = var.frontend_name
    }            
}
*/