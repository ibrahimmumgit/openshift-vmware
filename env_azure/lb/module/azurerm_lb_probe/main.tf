# LB Probe
resource "azurerm_lb_probe" "azlb" {
  name                = var.probe_name
  loadbalancer_id     = var.azlb_id
  protocol            = var.probe_protocol
  port                = var.probe_port
  probe_threshold     = var.probe_threshold
  request_path        = var.request_path
  interval_in_seconds = var.interval_in_seconds
  number_of_probes    = var.number_of_probes
}