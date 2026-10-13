locals {
  name_suffix = "${var.project}-${var.environment}"

  tags = {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  }

  acr_suffix = substr(md5(data.azurerm_subscription.current.subscription_id), 0, 6)
  acr_name   = "acr${var.project}${var.environment}${local.acr_suffix}"
}