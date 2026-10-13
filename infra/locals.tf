locals {
  name_suffix = "${var.project}-${var.environment}"

  tags = {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  }

  acr_suffix = substr(md5(data.azurerm_subscription.current.subscription_id), 0, 6)
  acr_name   = "acr${var.project}${var.environment}${local.acr_suffix}"

  db_admin_login = "squaredupadmin"

  # The generated password has no special characters, so it needs no URL encoding.
  # Sensitive because it contains the password.
  database_url = "postgresql://${local.db_admin_login}:${random_password.db_admin.result}@${module.database.server_fqdn}:5432/${module.database.database_name}?sslmode=require"

  app_image     = "${module.registry.login_server}/squaredup-app:${var.image_tag}"
  migrate_image = "${module.registry.login_server}/squaredup-migrate:${var.image_tag}"
}