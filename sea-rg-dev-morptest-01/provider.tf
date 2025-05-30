


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "=3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription
  client_id       = var.client_id
  client_secret   = var.client_secret 
  tenant_id       = var.tenant_id
}
