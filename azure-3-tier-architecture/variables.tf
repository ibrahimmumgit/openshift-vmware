variable "resource_group" {
    description = "This specifies the resource group of the virtual machine"
    default = "3tier-app"
    type = string
}   

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

variable "location" {
     description = "This specifies the location of the virtual machine" 
     default = "southeastasia"
     type = string
}

// variable "vnet_cidr" {
//     description = "This specifies the address apace of the web subnet"
//     type = string
// }

// variable "web_subnet_cidr" {
//     description = "This specifies the host name of the web-vm"
//     type = string
// }

// variable "app_subnet_cidr" {
//     description = "This specifies the address apace of the app subnet"
//     type = string
// }

// variable "db_subnet_cidr" {
//     description = "This specifies the address apace of the app subnet"
//     type = string
// }

// variable "web_subnet_id" {
//     description = "This specifies the address space of the web subnet"
//     type = string
// }

// variable "app_subnet_id" {
//     description = "This specifies the address space of the app subnet"
//     type = string
// }

// variable "db_subnet_id" {
//     description = "This specifies the address space of the db subnet"
//     type = string
// }

variable "web_host_name" {
    description = "This specifies the host name of the web-vm"
    type = string
    default = "webtier"
}

variable "web_username" {
    description = "This specifies the username of the web-vm"
    type = string
    default = "web_user"

}

variable "web_os_password" {
    description = "This specifies the passoword of the web-vm"
    type = string
    default = "Password!234"
sensitive   = true
}

variable "app_host_name" {
    description = "This specifies the host name of the app-vm"
    type = string
    default = "apptier"
}

variable "app_username" {
    description = "This specifies the username of the app-vm"
    type = string
    default = "app_user"
}

variable "app_os_password" {
    description = "This specifies the password of the app-vm"
    default = "Password!234"
    type = string
sensitive   = true
}

variable "dev_database" {
    description = "This specifies the database name"
    type = string
    default = "dbtier"
}

// variable "dev_database_version" {
//     description = "This specifies the version of the database"
//     type = string
// }

variable "dev_database_admin" {
    description = "This specifies the database administrator login"
    type = string
    default = "dbtest"
}

variable "dev_database_password" {
    description = "This specifies the administrator login password"
    type = string
    default = "Password!234"
sensitive   = true
}

