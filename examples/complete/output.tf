output "front_door_url" {
  value = {
    dog = module.cdn_frontdoor_endpoint_webapi["dog"].azurerm_cdn_frontdoor_endpoint.host_name
    cat = module.cdn_frontdoor_endpoint_webapi["cat"].azurerm_cdn_frontdoor_endpoint.host_name
    bird = module.cdn_frontdoor_endpoint_webapi["bird"].azurerm_cdn_frontdoor_endpoint.host_name
  }
}