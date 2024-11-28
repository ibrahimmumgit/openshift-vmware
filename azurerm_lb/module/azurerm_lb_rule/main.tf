# LB Rule
resource "azurerm_lb_rule" "azlb" {
  name                            = var.azlb_rule_name
  loadbalancer_id                 = var.azlb_id
  frontend_ip_configuration_name  = var.frontend_ip_configuration_name
  protocol                        = var.azlb_rule_protocol
  frontend_port                   = var.azlb_rule_frontend_port
  backend_port                    = var.azlb_rule_backend_port
  backend_address_pool_ids        = var.backend_address_pool_ids
  probe_id                        = var.probe_id
  enable_floating_ip              = var.enable_floating_ip
  idle_timeout_in_minutes         = var.idle_timeout_in_minutes
  load_distribution               = var.load_distribution
  disable_outbound_snat           = var.disable_outbound_snat
  enable_tcp_reset                = var.enable_tcp_reset
}