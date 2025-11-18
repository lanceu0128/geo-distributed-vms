resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.name_prefix}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.name_prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix    = "*" # TODO: change this
    destination_address_prefix = "*"
  }
}

locals {
  vm_map = { for name in var.vm_names : name => name }
}

module "vm" {
  source = "../vm"

  for_each = local.vm_map

  name_prefix         = "${var.name_prefix}-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id

  username            = var.username
  ssh_public_key      = var.ssh_public_key
}
