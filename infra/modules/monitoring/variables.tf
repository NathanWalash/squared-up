variable "name" {
  type        = string
  description = "Name of the Log Analytics workspace."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to create the workspace in."
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

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "How long logs are kept."
}

variable "daily_quota_gb" {
  type        = number
  default     = 0.5
  description = "Daily ingestion cap in GB, to limit cost."
}