resource "azurerm_resource_group" "main_rg" {
  name = "main_rg"
  location = "westeurope"
}


resource "azurerm_app_service_plan" "aps-mf-dev-01" {
  name                = "aps-mf-dev-01"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  sku {
    tier = "Standard"
    size = "S1"
    capacity = 1
  }
}

resource "azurerm_app_service" "app-mf-appdev01" {
  name                = "app-mf-appdev01"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  app_service_plan_id = azurerm_app_service_plan.aps-mf-dev-01.id

  app_settings = {
    "WEBSITE_DNS_SERVER" : "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL" : "1"
    "ENVNAME" : "app-mf-appdev01"
  }
}

resource "azurerm_monitor_diagnostic_setting" "app-mf-appdev01-monitoring" {
    #provider                      = azurerm.provider-log-analytics
    #count                         = (var.app_service_object.log_analytics != null && var.app_service_object.log_analytics != "") ? 1 : 0
    
    name                          = "diagnostics-${azurerm_app_service.app-mf-appdev01.name}"
    target_resource_id            = azurerm_app_service.app-mf-appdev01.id
    
    log_analytics_workspace_id    = azurerm_log_analytics_workspace.loganal01.id

    metric {
      category = "AllMetrics"

      retention_policy {
        enabled = false
      }
    }

    log {
        category = "AppServicePlatformLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }

    log {
        category = "AppServiceAppLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }

    log {
        category = "AppServiceAuditLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }

    log {
        category = "AppServiceConsoleLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }

    log {
        category = "AppServiceHTTPLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }

    log {
        category = "AppServiceIPSecAuditLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }

     log {
        category = "AppServicePlatformLogs"
        enabled  = true

        retention_policy {
            enabled = true
        }
    }
    
    
}

data "azurerm_monitor_diagnostic_categories" "azurerm_monitor_diagnostic_setting_azureappservice" {
  resource_id = azurerm_app_service.app-mf-appdev01.id
}

output "azurerm_monitor_diagnostic_setting_azureappservice_logs" {
   value = data.azurerm_monitor_diagnostic_categories.azurerm_monitor_diagnostic_setting_azureappservice.logs
}

output "azurerm_monitor_diagnostic_setting_azureappservice_metrics" {
   value = data.azurerm_monitor_diagnostic_categories.azurerm_monitor_diagnostic_setting_azureappservice.metrics
}