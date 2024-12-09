#variables 
variable "location" {
  type        = string
  default     = "southeastasia"
  description = "Resource group location"
}

variable "projectname" {
  description = "Name of the Project"
  default     = "agwcmp"
}
 


variable "environment" {
  description = "The Environment type (E.g: DEV,UAT,PROD)"
  type        = string
  default     = "DEV"
}

variable "sku" {
  description = "The Name of the sku use for this Application (E.g: Standar_V2,WAF_V2)"
  type        = string
  default     = "Standard_v2"
}

variable "frontend_ip_configuration_value" {
  description = " Frontend IP configuration (E.g: public,both)"
  type        = string
  default     = "both"
}

variable "private_ip" {
  description = "Provide Host IP"
  type        = string
  default     = "25"
}

variable "min_capacity" {
  description = "Autoscale Min capacity"
  type        = string
  default     = "1"
}

variable "max_capacity" {
  description = "Autoscale Max capacity"
  type        = string
  default     = "4"
}

variable "subnet_use" {
  description = "Subnet use for forntend configuration"
  type        = string
  default     = "public"
}



variable "request_routing_rule_name" {
  description = "Request routing rule name"
  type        = string
  default     = "default-rqrt"
}

variable "backend_address_pool_name" {
  description = "Backend address pool name"
  type        = string
  default     = "default-beap"
}


variable "backend_http_settings_name" {
  description = "Backend http settings name"
  type        = string
  default     = "default-be-htst"
}


variable "backend_http_settings_port" {
  description = "Backend http settings port"
  type        = number
  default     = "80"
}


variable "backend_http_settings_protocol" {
  description = "Backend http settings protocol"
  type        = string
  default     = "Http"
}


variable "listeners" {
  description = "A list of listener configurations with protocol and port"
  type = list(object({
    protocol          = string
    port              = number
    host_name         = optional(string)
    ssl_cert_data     = optional(string)
    ssl_cert_password = optional(string)
  }))
  default = [
    {
      protocol = "Http"
      port     = 80
    }
  ]
  validation {
    condition = alltrue([
      for listener in var.listeners :
      contains(["Http", "Https"], listener.protocol) && listener.port > 0 && listener.port <= 65535
    ])
    error_message = "Each listener must have a valid protocol ('Http' or 'Https') and port (1-65535)."
  }
}


variable "health_probes" {
  description = "List of Health probes used to test backend pools health."
  type = list(object({
    name                                      = string
    host                                      = string
    interval                                  = number
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = optional(number)
    pick_host_name_from_backend_http_settings = optional(bool)
    minimum_servers                           = optional(number)
  }))
  default = [
    {
      name                = "test_cmp_443"
      host                = "test.contoso.com"
      interval            = 60
      path                = "/"
      port                = 443
      timeout             = 180
      unhealthy_threshold = 3
      protocol            = "Https"

    },
    {
      name                = "test_cmp_444"
      host                = "test1.contoso.com"
      interval            = 60
      path                = "/"
      port                = 443
      timeout             = 180
      unhealthy_threshold = 3
      protocol            = "Https"

    }
  ]

}

variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    port                  = number
    protocol              = string
    request_timeout       = number
  }))
  default = [
    {
      name                  = "defaultHttpSetting"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 20

    }
  ]
}

variable "backend_address_pools" {
    description = "Backend address pools"
  type = list(object({
    name  = string
    fqdns = optional(list(string))
  }))
  default = [
    {
      name  = "backendAddressPool"
      fqdns = ["example1.contoso.com", "example2.contoso.com"]
    }
  ]
}

variable "appgw_rewrite_rule_set" {
  description = "Application Gateway Rewrite Rule Set"
  type = list(object({
    name                       = string
    rewrite_rules              = list(object({
      name                     = string
      rule_sequence            = number
      response_header_configurations = list(object({
        header_name            = string
        header_value           = string
      }))
    }))
  }))
  default = [
    {
      name = "example_rewrite_rule_set"

      rewrite_rules = [
        {
          name                     = "example_rewrite_rule"
          rule_sequence            = 100
          response_header_configurations = [
            {
              header_name          = "X-Content-Type-Options"
              header_value         = "nosniff"
            },
            {
              header_name          = "X-Frame-Options"
              header_value         = "DENY"
            }
          ]
        }
      ]
    }
  ]
}


#subscription
variable "subscription_id" {
  sensitive = true
}
variable "client_id" {
  sensitive = true
}
variable "client_secret" {
  sensitive = true
}
variable "tenant_id" {
  sensitive = true
}