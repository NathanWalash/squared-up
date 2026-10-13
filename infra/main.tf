resource "azurerm_resource_group" "app" {
  location = var.resource_group_location
  name     = "rg-${local.name_suffix}"
  tags     = local.tags
}