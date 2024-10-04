locals {


  tags = {
    event = "HashiCorp Meetup Thailand - Oct 4, 2024"
  }

  resource_shared = {
    app_service_plan = { type = "app_service_plan", name = "" }
    cat              = { type = "app_service", name = "cat" }
    dog              = { type = "app_service", name = "dog" }
    bird             = { type = "app_service", name = "bird" }

    cdn_frontdoor_endpoint_cat  = { type = "cdn_frontdoor_endpoint", name = "cat" }
    cdn_frontdoor_endpoint_dog  = { type = "cdn_frontdoor_endpoint", name = "dog" }
    cdn_frontdoor_endpoint_bird = { type = "cdn_frontdoor_endpoint", name = "bird" }
  }

  resource_attributes_group = {
    common = {
      shared_resource_attributes = {
        org               = "thw"
        project           = "fd"
        project_short     = "wstm"
        environment       = "dev"
        environment_short = "d"
        scope             = "common"
        scope_short       = "com"
        scope_shortest    = "com"
      }
      resource_attributes = {
        # Front Door & WAF
        cdn_frontdoor_profile         = { type = "cdn_frontdoor", name = "fd" }
        cdn_frontdoor_firewall_policy = { type = "cdn_frontdoor_firewall_policy", name = "fdfirewallpolicy" }
        cdn_frontdoor_security_policy = { type = "cdn_frontdoor_security_policy", name = "fd-security-policy" }
      }
    }
    webapi = {
      shared_resource_attributes = {
        org               = "thw"
        project           = "fd"
        project_short     = "wstm"
        environment       = "dev"
        environment_short = "d"
        scope             = "w"
        scope_short       = "w"
        scope_shortest    = "w"
      }
      resource_attributes = local.resource_shared
    }
    webapi_dr = {
      shared_resource_attributes = {
        org               = "thw"
        project           = "fd"
        project_short     = "wstm"
        environment       = "dev-dr"
        environment_short = "ddr"
        scope             = "w"
        scope_short       = "w"
        scope_shortest    = "w"
      }
      resource_attributes = local.resource_shared
    }
  }

  cdn_frontdoor = {

    security_policies_by_firewall_association = [
      {
        id = module.cdn_frontdoor_endpoint_webapi["cat"].azurerm_cdn_frontdoor_endpoint.id
      },
      {
        id = module.cdn_frontdoor_endpoint_webapi["dog"].azurerm_cdn_frontdoor_endpoint.id
      },
      {
        id = module.cdn_frontdoor_endpoint_webapi["bird"].azurerm_cdn_frontdoor_endpoint.id
      }
    ]
  }

  # ===== Manage Front Door =====

  shared_endpoint = {
    resource_group_name = azurerm_resource_group.main.name
    profile_id          = azurerm_cdn_frontdoor_profile.common.id
    profile_name        = azurerm_cdn_frontdoor_profile.common.name

    health_probe = {}
    origin_group = {}
  }

  endpoint_group = {

    webapi = {
      shared_attributes = {}
      attributes = {
        cat = {
          endpoint_name = module.naming_convention_webapi["cdn_frontdoor_endpoint_cat"].name
          origin_config = {
            active = {
              host_name = module.naming_convention_webapi["cat"].default_hostname
              weight    = 50
            }
            dr = {
              host_name = module.naming_convention_webapi_dr["cat"].default_hostname
              weight    = 50
            }
          }
        }

        dog = {
          endpoint_name = module.naming_convention_webapi["cdn_frontdoor_endpoint_dog"].name
          origin_config = {
            active = {
              host_name = module.naming_convention_webapi["dog"].default_hostname
              weight    = 50
            }
            dr = {
              host_name = module.naming_convention_webapi_dr["dog"].default_hostname
              weight    = 50
            }
          }
        }

        bird = {
          endpoint_name = module.naming_convention_webapi["cdn_frontdoor_endpoint_bird"].name
          origin_config = {
            active = {
              host_name = module.naming_convention_webapi["bird"].default_hostname
              weight    = 50
            }
            dr = {
              host_name = module.naming_convention_webapi_dr["bird"].default_hostname
              weight    = 50
            }
          }
        }
      }

    }

  }

}
