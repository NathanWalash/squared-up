resource "azurerm_container_app_environment" "this" {
  name                       = var.environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  tags                       = var.tags

  # Azure always adds this profile. Declaring it stops Terraform trying to remove it.
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_container_app" "this" {
  name                         = var.app_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  tags                         = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  registry {
    server   = var.registry_login_server
    identity = var.identity_id
  }

  # for_each cannot loop over a sensitive value, so loop over the secret
  # names (not sensitive) and look each value up.
  dynamic "secret" {
    for_each = nonsensitive(toset(keys(var.secrets)))
    content {
      name  = secret.value
      value = var.secrets[secret.value]
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = 0
    max_replicas = 1

    container {
      name   = "app"
      image  = var.image
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.secret_env
        content {
          name        = env.key
          secret_name = env.value
        }
      }
    }
  }
}
