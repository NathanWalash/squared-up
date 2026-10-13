variable "server_name" {
  type        = string
  description = "Name of the PostgreSQL server. Globally unique."
}

variable "database_name" {
  type        = string
  description = "Name of the database to create."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to create the server in."
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

variable "administrator_login" {
  type        = string
  description = "Admin username."
}

variable "administrator_password" {
  type        = string
  sensitive   = true
  description = "Admin password."
}

variable "sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "Server size."
}

variable "storage_mb" {
  type        = number
  default     = 32768
  description = "Storage in MB."
}

variable "postgres_version" {
  type        = string
  default     = "16"
  description = "PostgreSQL major version."
}

variable "client_ip" {
  type        = string
  default     = null
  description = "Optional public IP to allow, for connecting from your laptop."
}
