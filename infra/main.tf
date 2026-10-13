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
  image                      = "${module.registry.login_server}/hello:v1"

  depends_on = [module.registry]
}