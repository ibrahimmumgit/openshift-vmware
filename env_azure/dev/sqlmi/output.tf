output "managed_instane_dns" {
  value = azurerm_mssql_managed_instance.main.dns_zone

}
output "managed_instane_id" {
  value = azurerm_mssql_managed_instance.main.id
}
