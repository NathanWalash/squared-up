variable "environment_name" {
  type        = string
  description = "Name of the Container Apps environment."
}

variable "app_name" {
  type        = string
  description = "Name of the container app."
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

variable "log_analytics_workspace_id" {
  type        = string
  description = "Workspace the environment sends logs to."
}

variable "registry_login_server" {
  type        = string
  description = "Login server of the registry holding the image."
}

variable "identity_id" {
  type        = string
  description = "ID of the user-assigned identity that pulls the image."
}

variable "image" {
  type        = string
  description = "Full image reference to run."
}

variable "target_port" {
  type        = number
  default     = 80
  description = "Port the container listens on."
}
