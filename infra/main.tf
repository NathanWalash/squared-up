resource "azurerm_resource_group" "app" {
  location = var.resource_group_location
  name     = "rg-${local.name_suffix}"
  tags     = local.tags
}

module "monitoring" {
  source = "./modules/monitoring"

  name                = "log-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  tags                = local.tags
}

module "registry" {
  source = "./modules/registry"

  name                = local.acr_name
  identity_name       = "id-acrpull-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  tags                = local.tags
}

module "app" {
  source = "./modules/app"

  environment_name           = "cae-${local.name_suffix}"
  app_name                   = "ca-${local.name_suffix}"
  resource_group_name        = azurerm_resource_group.app.name
  location                   = azurerm_resource_group.app.location
  tags                       = local.tags
  log_analytics_workspace_id = module.monitoring.workspace_id
  registry_login_server      = module.registry.login_server
  identity_id                = module.registry.identity_id
  image                      = local.app_image
  target_port                = 3000
  secrets                    = { "database-url" = local.database_url }
  secret_env                 = { DATABASE_URL = "database-url" }

  depends_on = [module.registry]
}

module "migrate_job" {
  source = "./modules/job"

  name                  = "job-migrate-${local.name_suffix}"
  environment_id        = module.app.environment_id
  resource_group_name   = azurerm_resource_group.app.name
  location              = azurerm_resource_group.app.location
  tags                  = local.tags
  registry_login_server = module.registry.login_server
  identity_id           = module.registry.identity_id
  image                 = local.migrate_image
  secrets               = { "database-url" = local.database_url }
  secret_env            = { DATABASE_URL = "database-url" }

  depends_on = [module.registry]
}

resource "random_password" "db_admin" {
  length  = 24
  special = false
}

module "database" {
  source = "./modules/database"

  server_name            = "psql-${local.name_suffix}-${local.acr_suffix}"
  database_name          = "squaredup"
  resource_group_name    = azurerm_resource_group.app.name
  location               = azurerm_resource_group.app.location
  tags                   = local.tags
  administrator_login    = local.db_admin_login
  administrator_password = random_password.db_admin.result
  client_ip              = var.client_ip
}