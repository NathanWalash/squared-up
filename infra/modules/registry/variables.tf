variable "name" {
  type        = string
  description = "Registry name. Globally unique, alphanumeric only."
}

variable "identity_name" {
  type        = string
  description = "Name of the managed identity that pulls images."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to create the resources in."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply."
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "Registry SKU."
}