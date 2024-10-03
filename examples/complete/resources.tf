module "naming_convention_common" {
  source     = "./modules/naming_convention"
  for_each   = tomap(local.resource_attributes_group.common.resource_attributes)
  attributes = merge(local.resource_attributes_group.common.shared_resource_attributes, each.value)
}

module "naming_convention_webapi" {
  source     = "./modules/naming_convention"
  for_each   = tomap(local.resource_attributes_group.webapi.resource_attributes)
  attributes = merge(local.resource_attributes_group.webapi.shared_resource_attributes, each.value)
}

module "naming_convention_webapi_dr" {
  source     = "./modules/naming_convention"
  for_each   = tomap(local.resource_attributes_group.webapi_dr.resource_attributes)
  attributes = merge(local.resource_attributes_group.webapi_dr.shared_resource_attributes, each.value)
}

module "cdn_frontdoor_endpoint_webapi" {
  source     = "../../"
  for_each   = tomap(local.endpoint_group.webapi.attributes)
  attributes = merge(local.shared_endpoint, local.endpoint_group.webapi.shared_attributes, each.value)
}

resource "azurerm_resource_group" "main" {
  name     = "thw-event-front-door-demo"
  location = var.location_active
  tags     = local.tags
}

