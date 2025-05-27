// Variables defined 

// Set default RG Name
variable "subscription" { }    

// Set default RG Name
variable "RGName" { default = "sea-rg-dev-morptest-01" }                                                  

// Set default RG Location
variable "RGLocation" { default = "southeastasia" }

variable "client_id" {
  sensitive = true
}
variable "client_secret" {
  sensitive = true
}

variable "vm_tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    os                = "rhel"
    appname           = "infra"
    role              = "api"
    tier              = "backend"
    startandstop      = "weekdays=NA/weekends=NA"
    retention         = "na"
    requestedby       = "MadushankaPerera"
    businessowner     = "IT-Infra"
    businessunit      = "kibb"
    costcenter        = "2010130040"
    environment       = "dev"
    projectname       = "test"
  }
}

variable "adminpass" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure."
  type        = string
}

variable "adminuser" {
  description = "The admin username of the VM that will be deployed."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
  default     = ""
}

variable "mssqluser" {
  description = "The admin username of the VM that will be deployed."
  type        = string
}

variable "mssqlpass" {
  description = "The admin username of the VM that will be deployed."
  type        = string
}

variable "mysqluser" {
  description = "The admin username of the VM that will be deployed."
  type        = string
}

variable "mysqlpass" {
  description = "The admin username of the VM that will be deployed."
  type        = string
}