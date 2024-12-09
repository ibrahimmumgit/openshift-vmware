## Terraform code for AGW
# -
# - Application Gateway
# -

data "azurerm_web_application_firewall_policy" "waf"{
  name                = "ptsg-5iac-common-wafpolicy"
  resource_group_name = "PTAZSG-IAC-DEV-ASEAGW1-RG"
}

resource "azurerm_application_gateway" "agw" {
  depends_on            = [azurerm_user_assigned_identity.agw]
  name                = upper("PTAZSG-IAC-${var.environment}${var.projectname}-AGW01")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_http2        = true
  zones               = var.environment == "PROD" ? ["1","2","3"] : ["1"]
  firewall_policy_id  = var.sku == "WAF_v2" ? data.azurerm_web_application_firewall_policy.waf.id : null
  
  sku {
    name = var.sku
    tier = var.sku
  }

  autoscale_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agw.id]
  }
  ssl_policy {
    policy_type           = "Predefined"
    policy_name           = "AppGwSslPolicy20220101S"
    min_protocol_version  = "TLSv1_2"
  }



  gateway_ip_configuration {
    name      = var.subnet_use == "public" ? data.azurerm_subnet.public_subnet.name : data.azurerm_subnet.private_subnet.name
    subnet_id = var.subnet_use == "public" ? data.azurerm_subnet.public_subnet.id : data.azurerm_subnet.private_subnet.id 
  }


  frontend_ip_configuration {
    name                          = "public"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  #frontend_ip_configuration {
  #  name                          = var.subnet_use
  #  private_ip_address            = var.frontend_ip_configuration_value == "both" ? cidrhost(var.subnet_use == "public" ? data.azurerm_subnet.public_subnet.address_prefix : data.azurerm_subnet.private_subnet.address_prefix, var.private_ip) : null
  #  private_ip_address_allocation = "Static"
  #}

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration_value == "both" ? [1] : []
    content {
      name                          = "private"
      private_ip_address            = cidrhost( var.subnet_use == "public" ? data.azurerm_subnet.public_subnet.address_prefixes[0] : data.azurerm_subnet.private_subnet.address_prefixes[0] , var.private_ip) 
      private_ip_address_allocation = "Static"
      subnet_id                     = var.subnet_use == "public" ? data.azurerm_subnet.public_subnet.id : data.azurerm_subnet.private_subnet.id
    }
  }

  dynamic "frontend_port" {
    for_each = var.listeners
    content {
      name = "${frontend_port.value.protocol}-${frontend_port.value.port}"
      port = frontend_port.value.port
    }
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = var.backend_http_settings_port
    protocol              = var.backend_http_settings_protocol
    request_timeout       = 60
  }

  dynamic "http_listener" {
    for_each = { for idx, listener in var.listeners : idx => listener }
    content {
      name                           = "${http_listener.value.protocol}-${http_listener.value.port}-httplstn"
      frontend_ip_configuration_name = var.subnet_use
      frontend_port_name             = "${http_listener.value.protocol}-${http_listener.value.port}"
      protocol                       = http_listener.value.protocol

      ssl_certificate_name = http_listener.value.protocol == "Https" && http_listener.value.ssl_cert_data != "" ? "sslCert${http_listener.value.port}" : null
    }
  }

  dynamic "request_routing_rule" {
    for_each = { for idx, listener in var.listeners : idx => listener }
    content {
      name                       = "${request_routing_rule.value.port}-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "${request_routing_rule.value.protocol}-${request_routing_rule.value.port}-httplstn"
      backend_address_pool_name  = var.backend_address_pool_name
      backend_http_settings_name = var.backend_http_settings_name
      priority                   = 50 + request_routing_rule.key
    }
  }

    dynamic "probe" {
    for_each = var.health_probes
    content {
      name                                      = probe.value.name
      host                                      = lookup(probe.value, "host", "127.0.0.1")
      interval                                  = lookup(probe.value, "interval", 30)
      protocol                                  = probe.value.port == 443 ? "Https" : "Http"
      path                                      = lookup(probe.value, "path", "/")
      timeout                                   = lookup(probe.value, "timeout", 30)
      unhealthy_threshold                       = lookup(probe.value, "unhealthy_threshold", 3)
      port                                      = lookup(probe.value, "port", 443)
      pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", false)
      minimum_servers                           = lookup(probe.value, "minimum_servers", 0)
    }
  }

  dynamic "ssl_certificate" {
    for_each = { for idx, listener in var.listeners : idx => listener if listener.protocol == "Https"  }
    content {
      name     = "sslCert${ssl_certificate.value.port}"
      data     = ssl_certificate.value.ssl_cert_data
      password = ssl_certificate.value.ssl_cert_password
    }
  }
  # Define rewrite rule sets
  dynamic "rewrite_rule_set" {
    for_each = var.appgw_rewrite_rule_set
    content {
      name = rewrite_rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rules
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configurations
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }
        }
      }
    }
  }


}