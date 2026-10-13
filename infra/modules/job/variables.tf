variable "name" {
  type        = string
  description = "Name of the container app job."
}

variable "environment_id" {
  type        = string
  description = "ID of the Container Apps environment to run in."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to create the job in."
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

variable "secrets" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Job secrets, as secret name => value."
}

variable "env" {
  type        = map(string)
  default     = {}
  description = "Plain environment variables, as name => value."
}

variable "secret_env" {
  type        = map(string)
  default     = {}
  description = "Environment variables backed by a secret, as variable name => secret name."
}
