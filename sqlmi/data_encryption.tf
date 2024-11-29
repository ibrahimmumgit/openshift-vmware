resource "azurerm_mssql_managed_instance_transparent_data_encryption" "service_managed" {
  count                = var.use_custom_key ? 1 : 0
  managed_instance_id  = azurerm_mssql_managed_instance.main.id

  depends_on = [
    azurerm_mssql_managed_instance.main, # Ensure the managed instance exists
  ]
}

resource "azurerm_mssql_managed_instance_transparent_data_encryption" "customer_managed" {
  count                = !var.use_custom_key ? 1 : 0
  managed_instance_id  = azurerm_mssql_managed_instance.main.id
  key_vault_key_id     = data.azurerm_key_vault_key.vault_key[0].id

  depends_on = [
    azurerm_key_vault_key.key,               
    azurerm_key_vault_access_policy.mi_policy, 
    azurerm_key_vault_access_policy.user_identity_access, 
    azurerm_mssql_managed_instance.main,   
  ]
}
