terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "resource_groups" {
  description = "RGs, name prefixes, and locations."
  type = map(object({
    prefix   = string
    location = string
  }))
  default = {
    "Geo-Distributed-VM"  = { prefix = "eastus2",  location = "eastus2" }
    "Geo-Distributed-VM-East-US"  = { prefix = "eastus",  location = "eastus" }
    "Geo-Distributed-VM-WestUS"  = { prefix = "westus",   location = "westus" }
    "Geo-Distributed-VM-WestEU"  = { prefix = "westeu",   location = "westeurope" }
  }
}

data "azurerm_resource_group" "rgs" {
  for_each = var.resource_groups
  name     = each.key
}

module "vm" {
  for_each            = var.resource_groups
  source              = "./modules/vm"
  resource_group_name = each.key
  location            = each.value.location
  name_prefix         = each.value.prefix
  ssh_public_key      = var.ssh_public_key
}
