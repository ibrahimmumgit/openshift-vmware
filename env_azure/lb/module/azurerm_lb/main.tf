# Azure Load Balancer
resource "azurerm_lb" "azlb" {
  name                   = var.azlb_name
  resource_group_name    = var.azlb_rg_name
  location               = var.zlb_location_name
  edge_zone              = var.edge_zone
  sku                    = var.lb_sku # Basic (Retiring soon), Standard and Gateway ; this code supports Standard only
  sku_tier               = var.lb_sku_tier # Global and Regional ; this code supports Regional only; Global is allowed only when frontend ip is public
  tags                   = var.tags
  lifecycle {
    ignore_changes = [name]
  }
  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_count == 1 ? [1]:[1]
    content {
      name                          = var.frontend_name1
      subnet_id                     = try(var.subnet_id1, null)
      private_ip_address_allocation = try(var.private_ip_address_allocation1, "Dynamic")
      private_ip_address_version    = try(var.private_ip_address_version1, "IPv4")
      public_ip_address_id          = try(var.public_ip_address_id1, null)
    }
  }
  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_count == 2 ? [1]:[]
    content {
      name                          = try(var.frontend_name2, null)
      subnet_id                     = try(var.subnet_id2, null)
      private_ip_address_allocation = try(var.private_ip_address_allocation2, "Dynamic")
      private_ip_address_version    = try(var.private_ip_address_version2, "IPv4")
      public_ip_address_id          = try(var.public_ip_address_id2, null)
    }
  }
}