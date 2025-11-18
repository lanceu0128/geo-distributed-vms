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

// TODO use this again when we're ready
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

module "east_us_region" {
  source = "./modules/region"

  name_prefix         = "geo-eastus"
  location            = "eastus"
  resource_group_name = "Geo-Distributed-VM-East-US"

  vm_names            = ["vm1", "vm2"]

  username       = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "west_us_region" {
  source = "./modules/region"

  name_prefix         = "geo-eastus"
  location            = "eastus"
  resource_group_name = "Geo-Distributed-VM-WestUS"

  vm_names            = ["vm1", "vm2"]

  username       = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}