variable "resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-squaredup-dev"
  description = "Name of the app's resource group."
}