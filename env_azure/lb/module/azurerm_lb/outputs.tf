output "id" {
  value = azurerm_lb.azlb.id
}
output "frontend_ip_configuration" {
  value = azurerm_lb.azlb.frontend_ip_configuration
}
output "resource_group_name" {
  value = azurerm_lb.azlb.resource_group_name
}