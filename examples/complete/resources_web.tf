

locals {

  app_services = {
    cat = {
      name           = module.naming_convention_webapi["cat"].name
      site           = "active"
      ip_restriction = module.cdn_frontdoor_endpoint_webapi["cat"].azurerm_app_service_ip_restriction
    }
    dog = {
      name           = module.naming_convention_webapi["dog"].name
      site           = "active"
      ip_restriction = module.cdn_frontdoor_endpoint_webapi["dog"].azurerm_app_service_ip_restriction
    }
    bird = {
      name           = module.naming_convention_webapi["bird"].name
      site           = "active"
      ip_restriction = module.cdn_frontdoor_endpoint_webapi["bird"].azurerm_app_service_ip_restriction
    }
    cat_dr = {
      name           = module.naming_convention_webapi_dr["cat"].name
      site           = "dr"
      ip_restriction = module.cdn_frontdoor_endpoint_webapi["cat"].azurerm_app_service_ip_restriction
    }
    dog_dr = {
      name           = module.naming_convention_webapi_dr["dog"].name
      site           = "dr"
      ip_restriction = module.cdn_frontdoor_endpoint_webapi["dog"].azurerm_app_service_ip_restriction
    }
    bird_dr = {
      name           = module.naming_convention_webapi_dr["bird"].name
      site           = "dr"
      ip_restriction = module.cdn_frontdoor_endpoint_webapi["bird"].azurerm_app_service_ip_restriction
    }
  }
}

resource "azurerm_app_service_plan" "active" {
  name                = module.naming_convention_webapi["app_service_plan"].name
  location            = var.location_active
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true
  tags                = local.tags
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service_plan" "dr" {
  name                = module.naming_convention_webapi_dr["app_service_plan"].name
  location            = var.location_dr
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true
  tags                = local.tags
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "webapi" {
  for_each            = local.app_services
  name                = each.value.name
  resource_group_name = azurerm_resource_group.main.name
  location            = each.value.site == "active" ? var.location_active : var.location_dr
  app_service_plan_id = each.value.site == "active" ? azurerm_app_service_plan.active.id : azurerm_app_service_plan.dr.id
  https_only          = true
  tags                = local.tags

  site_config {
    linux_fx_version          = "DOTNETCORE|8.0"
    use_32_bit_worker_process = false
    always_on                 = true
    ftps_state                = "FtpsOnly"
    ip_restriction            = each.value.ip_restriction
  }

  app_settings = {
    # App Service Settings
    "MSDEPLOY_RENAME_LOCKED_FILES" = "1" # Prevent Locked files when deploy
    "APP_ID"                       = "${each.key}"
  }

}
