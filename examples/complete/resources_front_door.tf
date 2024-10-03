resource "azurerm_cdn_frontdoor_profile" "common" {
  name                     = module.naming_convention_common["cdn_frontdoor_profile"].name
  resource_group_name      = azurerm_resource_group.main.name
  sku_name                 = "Standard_AzureFrontDoor"
  response_timeout_seconds = 240
}

resource "azurerm_cdn_frontdoor_firewall_policy" "common" {
  name                = module.naming_convention_common["cdn_frontdoor_firewall_policy"].name
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = azurerm_cdn_frontdoor_profile.common.sku_name
  enabled             = true
  mode                = "Detection"
}

resource "azurerm_cdn_frontdoor_security_policy" "common" {
  name                     = module.naming_convention_common["cdn_frontdoor_security_policy"].name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.common.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.common.id

      association {
        dynamic "domain" {
          for_each = local.cdn_frontdoor.security_policies_by_firewall_association
          content {
            cdn_frontdoor_domain_id = domain.value.id
          }
        }

        patterns_to_match = ["/*"]
      }
    }
  }
}


