output "registry_name" {
  value = azurerm_container_registry.this.name
}

output "login_server" {
  value = azurerm_container_registry.this.login_server
}

output "registry_id" {
  value = azurerm_container_registry.this.id
}

output "identity_id" {
  value = azurerm_user_assigned_identity.pull.id
}

output "identity_client_id" {
  value = azurerm_user_assigned_identity.pull.client_id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.pull.principal_id
}