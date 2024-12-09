# Variable to control endpoint creation

variable "endpoint_setting" {
  type    = bool
  default = false  # Set to false to disable the endpoint
}

variable "sku_type" {
  type        = string
  description = "The pricing related information of current CDN profile."
  default     = "Standard_Microsoft"
}

# Variables for CDN Origin
variable "origin_type" {
  description = "Select the type of origin endpoint"
  type        = string
  default     = null 
}


variable "host_name" {
  description = "A string that determines the hostname/IP address of the origin server. This string can be a domain name, Storage Account endpoint, Web App endpoint, IPv4 address or IPv6 address."
  type        = string
  default     = null 
}

variable "query_string_caching_behavior" {
  description = "The query string caching behavior."
  type        = string
  default     = "IgnoreQueryString"
}

variable "http_port" {
  description = "The port for HTTP traffic."
  type        = number
  default     = 80  # Default HTTP port
}

variable "https_port" {
  description = "The port for HTTPS traffic."
  type        = number
  default     = 443  # Default HTTPS port
}

# Variable declarations for the Terraform configuration

variable "create_new_profile" {
  type    = bool
  default = false  # Set to false to disable the endpoint
}

variable "profile_name" {
  type    = string
  description = "Name of the Existing CDN Profile "
  default = null # Set to false to disable the endpoint
}


variable "resource_group_name" {
  description = "The name of the existing resource group where the Cosmos DB account will be created."
  type        = string
  default     = null
}

variable "location" {
  description = "The location for the resource group."
  type        = string
  default     = null
}

variable "environment" {
  description = "The environment type (e.g., DEV, UAT, PROD) for the deployment."
  type        = string
  default     = "DEV"
}

# Subscription Variables

variable "subscription_id" {
  sensitive   = true
  description = "The subscription ID for the Azure account."
}

variable "client_id" {
  sensitive   = true
  description = "The client ID for the Azure service principal."
}

variable "client_secret" {
  sensitive   = true
  description = "The client secret for the Azure service principal."
}

variable "tenant_id" {
  sensitive   = true
  description = "The tenant ID for the Azure Active Directory."
}