resource "azurerm_public_ip" "pubip" {
  name                = (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}pubip" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}pubip" : "5${local.effective_applicationname}pubip", local.existing_pubip_max_resource_numbers + 1))
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = "Standard"
  sku_tier            = "Regional"
  allocation_method   = "Static"
  ip_version          = "IPv4"
  tags = local.common_tags
  lifecycle {
    ignore_changes = [name]
  }
}

resource "azurerm_application_gateway" "ag" {
  name                  = (format("${var.rg_prefix}-%s%02d", local.effective_environment == "PROD" ? "1${local.effective_applicationname}agw" : local.effective_environment == "UAT" ? "4${local.effective_applicationname}agw" : "5${local.effective_applicationname}agw", local.existing_agw_max_resource_numbers + 1))
  resource_group_name   = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location              = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  lifecycle {
    ignore_changes = [name]
  }
  sku {
    name     = var.agw_sku
    tier     = var.agw_sku
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 10
  }

  enable_http2  = true

  gateway_ip_configuration {
    name      = var.agw_subnet_name
    subnet_id = data.azurerm_subnet.agw_subnet.id
  }

  firewall_policy_id = var.agw_sku == "WAF_v2" ? data.azurerm_web_application_firewall_policy.waf01[0].id : null

  tags = local.common_tags
################### Public Frontend Configuration - IP, Port, HTTP Listener ##############################
  frontend_ip_configuration {
    name                 = var.fe01pub_ip01_name
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
  frontend_port {
    name = var.fe01pub_port01_name
    port = var.fe01pub_port01
  }
  http_listener {
      name                           = var.fe01pub_lstr01_name
      #ssl_profile_name               = var.ssl_profile_name
      frontend_ip_configuration_name = var.fe01pub_ip01_name
      protocol                       = var.fe01pub_lstr01_protocol 
      frontend_port_name             = var.fe01pub_port01_name
      #ssl_certificate_name           = var.ssl_cert_apimportal
      require_sni                    = var.fe01pub_lstr01_protocol == "Https" ? true : false
      host_name                      = var.fe01pub_lstr01_hostname
  }
  ################### Private Frontend Configuration - IP, Port, HTTP Listener ##############################
  dynamic frontend_ip_configuration {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
    name                          = var.fe01pri_ip01_name
    private_ip_address            = var.fe01pri_ip01
    private_ip_address_allocation = "Static"
    subnet_id                     = data.azurerm_subnet.agw_subnet.id
    }
  }
  dynamic frontend_port {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
    name = var.fe01pri_port01_name
    port = var.fe01pri_port01
    }
  }
  dynamic http_listener {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
      name                           = var.fe01pri_lstr01_name
     # ssl_profile_name               = var.ssl_profile_name
      frontend_ip_configuration_name = var.fe01pri_ip01_name
      protocol                       = var.fe01pri_lstr01_protocol
      frontend_port_name             = var.fe01pri_port01_name
      #ssl_certificate_name           = var.ssl_cert_apimportal
      require_sni                    = var.fe01pri_lstr01_protocol == "Https" ? true : false
      host_name                      = var.fe01pri_lstr01_hostname
    }
  }
###################### SSL Configuration ############################
/*
  ssl_profile {
    name  = var.ssl_profile_name
    ssl_policy {
      policy_type = "Custom"
      cipher_suites = ["TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256","TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384","TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256","TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384","TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256","TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384","TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256","TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384"]
      min_protocol_version = "TLSv1_2"
    }
  }
  
  identity {
    type         = var.identity_type
    identity_ids = [module.mi.id]
  }

  ssl_certificate {
    name = var.ssl_cert_apimportal 
    key_vault_secret_id = "https://${var.key_vault_name}.vault.azure.net/secrets/${var.ssl_cert_apimportal}"
  }

  ssl_certificate {
    name = var.ssl_cert_apimmgmt
    key_vault_secret_id = "https://${var.key_vault_name}.vault.azure.net/secrets/${var.ssl_cert_apimmgmt}" 
  }

  ssl_certificate {
    name = var.ssl_cert_moapp
    key_vault_secret_id = "https://${var.key_vault_name}.vault.azure.net/secrets/${var.ssl_cert_moapp}" 
  }

  trusted_root_certificate {
    name = var.trusted_root_certificate_name_string #"root-testesunapim"
    data = filebase64("${path.module}/mvc_cer_test/root/${var.trusted_root_certificate_name_string}.cer")
  }
*/
################### Backend Configuration for Public Frontend - backend_address_pool, Probe, backend_http_settings ##############################
  backend_address_pool {
      name = var.fe01pub_be01_name
      ip_addresses = split(",",var.fe01pub_be01_ip)
  }
  probe {
      name = var.fe01pub_be01_probe01_name
      protocol = var.fe01pub_be01_probe01_protocol
      pick_host_name_from_backend_http_settings = true
      path = var.fe01pub_be01_probe01_path
      interval = "60" 
      timeout = "300" 
      unhealthy_threshold = "8" 
  }
    backend_http_settings {
    name                  = var.fe01pub_be01_setting01_name
    protocol              = var.fe01pub_be01_setting01_protocol
    port                  = var.fe01pub_be01_setting01_port
    cookie_based_affinity = "Disabled" 
    request_timeout       = "180" 
    host_name             = var.fe01pub_be01_setting01_hostname
    probe_name            = var.fe01pub_be01_probe01_name
    #trusted_root_certificate_names      = var.trusted_root_certificate_names
  }
################### Backend Configuration for Private Frontend - backend_address_pool, Probe, backend_http_settings ##############################
  dynamic backend_address_pool {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
    name = var.fe01pri_be01_name
    ip_addresses = split(",",var.fe01pri_be01_ip)
    }
  }
  dynamic probe {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
      name = var.fe01pri_be01_probe01_name
      protocol = var.fe01pri_be01_probe01_protocol
      pick_host_name_from_backend_http_settings = true
      path = var.fe01pri_be01_probe01_path
      interval = "60" 
      timeout = "300" 
      unhealthy_threshold = "8" 
    }
  }
  dynamic backend_http_settings {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
    name                  = var.fe01pri_be01_setting01_name
    protocol              = var.fe01pri_be01_setting01_protocol
    port                  = var.fe01pri_be01_setting01_port
    cookie_based_affinity = "Disabled" 
    request_timeout       = "180" 
    host_name             = var.fe01pri_be01_setting01_hostname
    probe_name            = var.fe01pri_be01_probe01_name
    #trusted_root_certificate_names      = var.trusted_root_certificate_names
    }
  }
############################################# Routing Rule for Public FrontEnd ############################################
  request_routing_rule {
      name                       = var.fe01pub_be01_rule01_name
      priority                   = "1" 
      http_listener_name         = var.fe01pub_lstr01_name
      backend_address_pool_name  = var.fe01pub_be01_name
      backend_http_settings_name = var.fe01pub_be01_setting01_name
      rule_type                  = "Basic"
  }
############################################# Routing Rule for Private FrontEnd ############################################
  dynamic request_routing_rule {
    for_each                         = var.is_public_only == false ? [1] : []
    content {
      name                       = var.fe01pri_be01_rule01_name
      priority                   = "2" 
      http_listener_name         = var.fe01pri_lstr01_name
      backend_address_pool_name  = var.fe01pri_be01_name
      backend_http_settings_name = var.fe01pri_be01_setting01_name
      rule_type                  = "Basic"
    }
  }
}
###############################################################
# Application Insights creation (conditionally created based on enable_monitoring and create_new_application_insigts variables)
resource "azurerm_log_analytics_workspace" "alaw" {
  count               = var.enable_monitoring && var.create_new_log_analytics_workspace ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-log" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-log" : "-5${local.effective_applicationname}-log"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  sku                 = var.alaw_sku
  retention_in_days   = 30
  tags                = local.common_tags
  lifecycle {
    ignore_changes = [name]
  }
}
/*
resource "azurerm_application_insights" "aai" {
  count               = var.enable_monitoring && var.create_new_application_insigts ? 1 : 0
  name                = lower("${var.rg_prefix}${local.effective_environment == "PROD" ? "-1${local.effective_applicationname}-appins" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}-appins" : "-5${local.effective_applicationname}-appins"}")
  resource_group_name = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  location            = var.create_new_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  workspace_id        = azurerm_log_analytics_workspace.alaw[0].id
  application_type    = "other"
  tags                = local.common_tags
  lifecycle {
    ignore_changes = [name]
  }
}
*/
resource "azurerm_monitor_diagnostic_setting" "logds" {
  count               = var.enable_monitoring ? 1 : 0
  name               = "diagnostic_setting01"
  target_resource_id = azurerm_application_gateway.ag.id
  log_analytics_workspace_id = var.create_new_log_analytics_workspace ? azurerm_log_analytics_workspace.alaw[0].id : data.azurerm_log_analytics_workspace.alaw[0].id
  metric {
      category = "AllMetrics"
  }
  enabled_log {
    category_group = "allLogs"
  }
  lifecycle {
    ignore_changes = [name]
  }
}