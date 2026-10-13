variable "resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of the resource group."
}

variable "project" {
  type        = string
  default     = "squaredup"
  description = "Project name, used in resource names and tags."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name."

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}

variable "alert_email" {
  type        = string
  description = "Email address for budget alerts."
}

variable "budget_amount" {
  type        = number
  default     = 20
  description = "Monthly budget in your billing currency."
}

variable "image_tag" {
  type        = string
  default     = "v1"
  description = "Tag of the squaredup-app and squaredup-migrate images in the registry."
}

variable "client_ip" {
  type        = string
  default     = null
  description = "Your public IP, to allow connecting to the database from your laptop."
}