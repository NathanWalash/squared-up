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

output "app_url" {
  value = "https://${module.app.fqdn}"
}

output "migrate_job_name" {
  value = module.migrate_job.name
}

output "db_server_fqdn" {
  value = module.database.server_fqdn
}

output "db_name" {
  value = module.database.database_name
}