data "azurerm_subscription" "current" {}

resource "azurerm_consumption_budget_subscription" "monthly" {
  name            = "budget-${local.name_suffix}"
  subscription_id = data.azurerm_subscription.current.id
  amount          = var.budget_amount
  time_grain      = "Monthly"

  time_period {
    start_date = "2026-10-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }

  notification {
    enabled        = true
    threshold      = 75
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }

  notification {
    enabled        = true
    threshold      = 90
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }
}