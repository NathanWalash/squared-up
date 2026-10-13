output "resource_group_name" {
  value = azurerm_resource_group.app.name
}

output "resource_group_id" {
  value = azurerm_resource_group.app.id
}

output "acr_login_server" {
  value = module.registry.login_server
}

output "acr_name" {
  value = module.registry.registry_name
}