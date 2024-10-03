terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
    }
  }
}

locals {
  # Fallback when origin_host_header is not provided
  origin_host_header = var.attributes.origin.origin_host_header == null ? var.attributes.origin.host_name : var.attributes.origin.origin_host_header
}

resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                           = "${var.attributes.endpoint_name}-origin-${var.attributes.name}"
  cdn_frontdoor_origin_group_id  = var.attributes.origin_group_id
  enabled                        = var.attributes.origin.enabled
  host_name                      = var.attributes.origin.host_name
  origin_host_header             = local.origin_host_header
  certificate_name_check_enabled = var.attributes.origin.certificate_name_check_enabled
  http_port                      = var.attributes.origin.http_port
  https_port                     = var.attributes.origin.https_port
  priority                       = var.attributes.origin.priority
  weight                         = var.attributes.origin.weight
}

