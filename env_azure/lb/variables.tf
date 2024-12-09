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
  description = "Flag to indicate whether to create new log analytics workspace or not. (E.g: true, false)"
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
######### LB Variables ###################
variable "is_public" {
  description = "is_public"
  type        = bool
  default     = false
}
variable "frontend_count" {
  type        = number
  default     = 1
}
/*
variable "pubip01_name" {
  description = "pubip_details"
  type        = string
  default     = null
}
variable "pubip02_name" {
  description = "pubip_details"
  type        = string
  default     = null
}
*/
variable "lb_vnet_network_details" {
  description = "lb_vnet_network_details (vnet_name - subnet_name)"
  type        = string
  default     = null
}
variable "lb_vnet_resource_group_name" {
  description = "Name of the existing resource group where VNET for LB resides."
  type        = string
  default     = null
}
/*
variable "pubip_resource_group_name" {
  description = "Name of the existing resource group where Public IP resides."
  type        = string
  default     = null
}
*/
variable "vm_resource_group_name" {
  description = "Name of the existing resource group where VM resides."
  type        = string
  default     = null
}
variable "fe01_backend_address_pool_count" {
  description = "backend_address_pool_count"
  type        = number
  default     = 1
}
variable "fe02_backend_address_pool_count" {
  description = "backend_address_pool_count"
  type        = number
  default     = 1
}
variable "fe01_be01_vm_count" {
  type        = number
  default     = 1
}
variable "fe01_be02_vm_count" {
  type        = number
  default     = 1
}
variable "fe02_be01_vm_count" {
  type        = number
  default     = 1
}
variable "fe02_be02_vm_count" {
  type        = number
  default     = 1
}
###### Probe Variables #########
variable "fe01_be01_probe_protocol" {
  type        = string
  default     = null
}
variable "fe01_be01_probe_port" {
  type        = number
  default     = null
}
variable "fe01_be01_probe_request_path" {
  type        = string
  default     = null
}
variable "fe01_be01_probe_threshold" {
  type        = number
  default     = null
}
variable "fe01_be01_probe_interval_in_seconds" {
  type        = number
  default     = null
}
variable "fe01_be01_probe_number_of_probes" {
  type        = number
  default     = null
}
############
variable "fe01_be02_probe_protocol" {
  type        = string
  default     = null
}
variable "fe01_be02_probe_port" {
  type        = number
  default     = null
}
variable "fe01_be02_probe_request_path" {
  type        = string
  default     = null
}
variable "fe01_be02_probe_threshold" {
  type        = number
  default     = null
}
variable "fe01_be02_probe_interval_in_seconds" {
  type        = number
  default     = null
}
variable "fe01_be02_probe_number_of_probes" {
  type        = number
  default     = null
}
#########################
variable "fe02_be01_probe_protocol" {
  type        = string
  default     = null
}
variable "fe02_be01_probe_port" {
  type        = number
  default     = null
}
variable "fe02_be01_probe_request_path" {
  type        = string
  default     = null
}
variable "fe02_be01_probe_threshold" {
  type        = number
  default     = null
}
variable "fe02_be01_probe_interval_in_seconds" {
  type        = number
  default     = null
}
variable "fe02_be01_probe_number_of_probes" {
  type        = number
  default     = null
}
###########################
variable "fe02_be02_probe_protocol" {
  type        = string
  default     = null
}
variable "fe02_be02_probe_port" {
  type        = number
  default     = null
}
variable "fe02_be02_probe_request_path" {
  type        = string
  default     = null
}
variable "fe02_be02_probe_threshold" {
  type        = number
  default     = null
}
variable "fe02_be02_probe_interval_in_seconds" {
  type        = number
  default     = null
}
variable "fe02_be02_probe_number_of_probes" {
  type        = number
  default     = null
}
#################### LB RULE Variables #######################
variable "fe01_be01_rule_protocol" {
  type        = string
  default     = null
}
variable "fe01_be01_rule_frontend_port" {
  type        = number
  default     = null
}
variable "fe01_be01_rule_backend_port" {
  type        = number
  default     = null
}
variable "fe01_be01_rule_enable_floating_ip" {
  type        = bool
  default     = null
}
variable "fe01_be01_rule_idle_timeout_in_minutes" {
  type        = number
  default     = null
}
variable "fe01_be01_rule_load_distribution" {
  type        = string
  default     = null
}
variable "fe01_be01_rule_disable_outbound_snat" {
  type        = bool
  default     = null
}
variable "fe01_be01_rule_enable_tcp_reset" {
  type        = bool
  default     = null
}

variable "fe01_be02_rule_protocol" {
  type        = string
  default     = null
}
variable "fe01_be02_rule_frontend_port" {
  type        = number
  default     = null
}
variable "fe01_be02_rule_backend_port" {
  type        = number
  default     = null
}
variable "fe01_be02_rule_enable_floating_ip" {
  type        = bool
  default     = null
}
variable "fe01_be02_rule_idle_timeout_in_minutes" {
  type        = number
  default     = null
}
variable "fe01_be02_rule_load_distribution" {
  type        = string
  default     = null
}
variable "fe01_be02_rule_disable_outbound_snat" {
  type        = bool
  default     = null
}
variable "fe01_be02_rule_enable_tcp_reset" {
  type        = bool
  default     = null
}

variable "fe02_be01_rule_protocol" {
  type        = string
  default     = null
}
variable "fe02_be01_rule_frontend_port" {
  type        = number
  default     = null
}
variable "fe02_be01_rule_backend_port" {
  type        = number
  default     = null
}
variable "fe02_be01_rule_enable_floating_ip" {
  type        = bool
  default     = null
}
variable "fe02_be01_rule_idle_timeout_in_minutes" {
  type        = number
  default     = null
}
variable "fe02_be01_rule_load_distribution" {
  type        = string
  default     = null
}
variable "fe02_be01_rule_disable_outbound_snat" {
  type        = bool
  default     = null
}
variable "fe02_be01_rule_enable_tcp_reset" {
  type        = bool
  default     = null
}

variable "fe02_be02_rule_protocol" {
  type        = string
  default     = null
}
variable "fe02_be02_rule_frontend_port" {
  type        = number
  default     = null
}
variable "fe02_be02_rule_backend_port" {
  type        = number
  default     = null
}
variable "fe02_be02_rule_enable_floating_ip" {
  type        = bool
  default     = null
}
variable "fe02_be02_rule_idle_timeout_in_minutes" {
  type        = number
  default     = null
}
variable "fe02_be02_rule_load_distribution" {
  type        = string
  default     = null
}
variable "fe02_be02_rule_disable_outbound_snat" {
  type        = bool
  default     = null
}
variable "fe02_be02_rule_enable_tcp_reset" {
  type        = bool
  default     = null
}
############################ NIC Association ##########
variable "fe01_be01_vm01_interface_name" {
  type        = string
  default     = null
}
variable "fe01_be01_vm02_interface_name" {
  type        = string
  default     = null
}
variable "fe01_be02_vm01_interface_name" {
  type        = string
  default     = null
}
variable "fe01_be02_vm02_interface_name" {
  type        = string
  default     = null
}
variable "fe02_be01_vm01_interface_name" {
  type        = string
  default     = null
}
variable "fe02_be01_vm02_interface_name" {
  type        = string
  default     = null
}
variable "fe02_be02_vm01_interface_name" {
  type        = string
  default     = null
}
variable "fe02_be02_vm02_interface_name" {
  type        = string
  default     = null
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

