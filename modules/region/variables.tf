
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "name_prefix"         { type = string }
variable "username"            { type = string }
variable "ssh_public_key"      { type = string }

variable "vnet_address_space" {
  description = "Address space for the VNet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_names" {
  description = "List of VM name suffixes to create in this region."
  type        = list(string)
}
