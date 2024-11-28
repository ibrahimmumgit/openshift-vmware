# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "azlb" {
  loadbalancer_id = var.azlb_id
  name            = var.backend_address_pool_name
  synchronous_mode = var.backend_address_pool_syncmode
  virtual_network_id =     var.azlb_vnet_id
}