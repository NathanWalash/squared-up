terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-squaredup-tfstate"
    storage_account_name = "squaredupstate"
    container_name       = "tfstate"
    key                  = "app.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {
    # Without this, a destroyed workspace is only soft-deleted for 14 days and
    # recreating one with the same name fails.
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
  resource_provider_registrations = "none"
}