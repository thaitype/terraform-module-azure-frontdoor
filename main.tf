terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
    }
  }
}

locals {
  enable_custom_domain = var.attributes.custom_domain == null ? false : var.attributes.custom_domain.enable
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = var.attributes.endpoint_name
  cdn_frontdoor_profile_id = var.attributes.profile_id
}

data "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                = var.attributes.endpoint_name
  profile_name        = var.attributes.profile_name
  resource_group_name = var.attributes.resource_group_name

  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint
  ]
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = "${var.attributes.endpoint_name}-origin-group"
  cdn_frontdoor_profile_id = var.attributes.profile_id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = var.attributes.origin_group.load_balancing.sample_size
    successful_samples_required = var.attributes.origin_group.load_balancing.successful_samples_required
  }

  health_probe {
    path                = var.attributes.health_probe.path
    request_type        = var.attributes.health_probe.request_type
    protocol            = var.attributes.health_probe.protocol
    interval_in_seconds = var.attributes.health_probe.interval_in_seconds
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "${var.attributes.endpoint_name}-route" # remove `-active` after merged
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  cdn_frontdoor_origin_ids      = [for origin in module.cdn_frontdoor_origin : origin.azurerm_cdn_frontdoor_origin.id]

  supported_protocols    = var.attributes.route.supported_protocols
  patterns_to_match      = var.attributes.route.patterns_to_match
  forwarding_protocol    = var.attributes.route.forwarding_protocol
  https_redirect_enabled = var.attributes.route.https_redirect_enabled

  # For custom domain
  # (Optional) Should this Front Door Route be linked to the default endpoint? Possible values include true or false. Defaults to true.
  link_to_default_domain          = local.enable_custom_domain ? false : true
  cdn_frontdoor_custom_domain_ids = local.enable_custom_domain ? [azurerm_cdn_frontdoor_custom_domain.custom_domain[0].id] : []
}


resource "azurerm_cdn_frontdoor_custom_domain" "custom_domain" {
  count                    = local.enable_custom_domain ? 1 : 0
  name                     = "${var.attributes.endpoint_name}-custom-domain"
  cdn_frontdoor_profile_id = var.attributes.profile_id
  host_name                = var.attributes.custom_domain.host_name

  tls {
    certificate_type    = var.attributes.custom_domain.tls.certificate_type
    minimum_tls_version = var.attributes.custom_domain.tls.minimum_tls_version
  }
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "custom_domain_association" {
  count                          = local.enable_custom_domain ? 1 : 0
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.custom_domain[0].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.route.id]
}


module "cdn_frontdoor_origin" {
  source   = "./azurerm_cdn_frontdoor_origin"
  for_each = var.attributes.origin_config
  attributes = {
    endpoint_name   = var.attributes.endpoint_name,
    origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id,
    name            = each.key,
    origin          = each.value
  }
}

module "app_service_ip_restriction_frontdoor" {
  source = "./azurerm_app_service_ip_restriction_frontdoor"
  attributes = {
    allow_hostname = local.enable_custom_domain ? [
      var.attributes.custom_domain.host_name,
      azurerm_cdn_frontdoor_endpoint.endpoint.host_name
      ] : [
      azurerm_cdn_frontdoor_endpoint.endpoint.host_name
    ]
  }
}
