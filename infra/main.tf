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