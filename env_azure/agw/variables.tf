########## Subscription
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
############# Common Variables ###########
variable "applicationname" {
  description = "Name of the Project where the Azure FunctionApp Service will be deployed."
  type        = string
  default     = null
}
variable "location" {
  description = "Resource group location"
  type        = string
  default     = null
}
variable "environment" {
  description = "The Environment type (E.g: DEV, UAT, PROD)"
  type        = string
  default     = null
}
variable "rg_prefix" {
  description = "resource group prefix"
  type        = string
  default     = null
}
variable "create_new_resource_group" {
  description = "Flag to indicate whether to create a new resource group. (E.g: true, false)"
  type        = bool
  default     = null
}
variable "resource_group_name" {
  description = "Name of the existing resource group."
  type        = string
  default     = null
}
variable "role_access" {
  type        = string
  default     = null
}
variable "custom_role_name" {
  type        = string
  default     = null
}
variable "enable_monitoring" {
  description = "Flag to indicate whether to enable monitoring. (E.g: true, false)"
  type        = bool
  default     = false
}
variable "create_new_log_analytics_workspace" {
  description = "Flag to indicate whether to create new log analytics. (E.g: true, false)"
  type        = bool
  default     = false
}
variable "existing_log_analytics_workspace_name" {
  type        = string
  default     = null
}
variable "alaw_sku" {
  description = "SKU for Azure Log Analytics"
  type        = string
  default     = "PerGB2018"
}
################################################ AGW Variable #################################################
variable "agw_sku" {
  description = "Standard_v2 OR WAF_v2"
  type        = string
  default     = "Standard_v2"
}
variable "waf01_name" {
  description = "WAF Name"
  type        = string
  default     = "waf01"
}
variable "waf01_resource_group_name" {
  description = "Name of the existing resource group where WAF resides."
  type        = string
  default     = null
}
variable "is_public_only" {
  description = "Flag to indicate whether AGW is (Public Only) or (Public & Private).  (E.g: true, false)"
  type        = bool
  default     = true
}
#### Public Frontend Configuration - IP, Port, HTTP Listener ######
/*
variable "pubip01_name" {
  description = "pubip_details"
  type        = string
  default     = null
}
variable "pubip_resource_group_name" {
  description = "Name of the existing resource group where Public IP resides."
  type        = string
  default     = null
}
*/
variable "agw_vnet_network_details" {
  description = "agw_vnet_network_details (vnet_name - subnet_name)"
  type        = string
  default     = null
}
variable "agw_vnet_resource_group_name" {
  description = "Name of the existing resource group where VNET for LB resides."
  type        = string
  default     = null
}
variable "fe01pub_port01" {
  type        = number
  default     = null
}
variable "fe01pub_lstr01_protocol" {
  type        = string
  default     = null
}
variable "fe01pub_lstr01_hostname" {
  type        = string
  default     = null
}
#### Private Frontend Configuration - IP, Port, HTTP Listener ######
variable "fe01pri_ip01" {
  type        = string
  default     = "10.0.0.9"
}
variable "fe01pri_port01" {
  type        = number
  default     = 8080
}
variable "fe01pri_lstr01_protocol" {
  type        = string
  default     = "Http"
}
variable "fe01pri_lstr01_hostname" {
  type        = string
  default     = "host1.example.com"
}
### Backend Configuration for Public Frontend - backend_address_pool, Probe, backend_http_settings ###
variable "fe01pub_be01_ip" {
  type        = string
  default     = null
}
variable "fe01pub_be01_probe01_protocol" {
  type        = string
  default     = null
}
variable "fe01pub_be01_probe01_path" {
  type        = string
  default     = null
}
variable "fe01pub_be01_setting01_protocol" {
  type        = string
  default     = null
}
variable "fe01pub_be01_setting01_port" {
  type        = number
  default     = null
}
variable "fe01pub_be01_setting01_hostname" {
  type        = string
  default     = null
}
### Backend Configuration for Private Frontend - backend_address_pool, Probe, backend_http_settings ###
variable "fe01pri_be01_ip" {
  type        = string
  default     = "10.0.0.10"
}
variable "fe01pri_be01_probe01_protocol" {
  type        = string
  default     = "Http"
}
variable "fe01pri_be01_probe01_path" {
  type        = string
  default     = "/"
}
variable "fe01pri_be01_setting01_protocol" {
  type        = string
  default     = "Http"
}
variable "fe01pri_be01_setting01_port" {
  type        = number
  default     = 8080
}
variable "fe01pri_be01_setting01_hostname" {
  type        = string
  default     = "host1.example.com"
}
######################################################## AGW Fixed Value Variable ##########################################
variable "agw_subnet_name" {
  type        = string
  default     = "agw_subnet"
}
variable "ssl_profile_name" {
  type        = string
  default     = "ssl_profile01"
}
#### Public Frontend Configuration - IP, Port, HTTP Listener ######
variable "fe01pub_ip01_name" {
  type        = string
  default     = "fe01pub_ip01"
}
variable "fe01pub_port01_name" {
  type        = string
  default     = "fe01pub_port01"
}
variable "fe01pub_lstr01_name" {
  type        = string
  default     = "fe01pub_lstr01"
}
#### Private Frontend Configuration - IP, Port, HTTP Listener ######
variable "fe01pri_ip01_name" {
  type        = string
  default     = "fe01pri_ip01"
}
variable "fe01pri_port01_name" {
  type        = string
  default     = "fe01pri_port01"
}
variable "fe01pri_lstr01_name" {
  type        = string
  default     = "fe01pri_lstr01"
}
### Backend Configuration for Public Frontend - backend_address_pool, Probe, backend_http_settings ###
variable "fe01pub_be01_name" {
  type        = string
  default     = "fe01pub_be01"
}
variable "fe01pub_be01_probe01_name" {
  type        = string
  default     = "fe01pub_be01_probe01"
}
variable "fe01pub_be01_setting01_name" {
  type        = string
  default     = "fe01pub_be01_setting01"
}
### Backend Configuration for Private Frontend - backend_address_pool, Probe, backend_http_settings ###
variable "fe01pri_be01_name" {
  type        = string
  default     = "fe01pri_be01"
}
variable "fe01pri_be01_probe01_name" {
  type        = string
  default     = "fe01pri_be01_probe01"
}
variable "fe01pri_be01_setting01_name" {
  type        = string
  default     = "fe01pri_be01_setting01"
}
### Routing Rule for Public & Private FrontEnd ###
variable "fe01pub_be01_rule01_name" {
  type        = string
  default     = "fe01pub_be01_rule01"
}
variable "fe01pri_be01_rule01_name" {
  type        = string
  default     = "fe01pri_be01_rule01"
}

####### tags #####################
variable "project_code" {
  description = "The project code"
  type        = string
  default     = null
}
variable "applicationid" {
  description = "The application ID"
  type        = string
  default     = null
}
variable "costcenter" {
  description = "The cost center"
  type        = string
  default     = null
}
variable "dataclassification" {
  description = "The data classification"
  type        = string
  default     = null
}
variable "scaclassification" {
  description = "The SCA classification"
  type        = string
  default     = null
}
variable "iacrepo" {
  description = "The IAC repository"
  type        = string
  default     = null
}
variable "productowner" {
  description = "The product owner"
  type        = string
  default     = null
}
variable "productsupport" {
  description = "The product support team"
  type        = string
  default     = null
}
variable "businessowner" {
  description = "The business owner"
  type        = string
  default     = null
}
variable "csbia_availability" {
  description = "CSBIA Availability"
  type        = string
  default     = null
}
variable "csbia_confidentiality" {
  description = "CSBIA Confidentiality"
  type        = string
  default     = null
}
variable "csbia_impactscore" {
  description = "CSBIA Impact Score"
  type        = string
  default     = null
}
variable "csbia_integrity" {
  description = "CSBIA Integrity"
  type        = string
  default     = null
}
variable "businessopu_hcu" {
  description = "Business OPU/HCU"
  type        = string
  default     = null
}
variable "businessstream" {
  description = "The business stream"
  type        = string
  default     = null
}
/*
variable "srnumber" {
  description = "The SR number"
  type        = string
  default     = null
}
*/