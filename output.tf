output "azurerm_cdn_frontdoor_endpoint" {
  value = {
    id = azurerm_cdn_frontdoor_endpoint.endpoint.id
    host_name = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
  }
}

output "azurerm_app_service_ip_restriction" {
  value = module.app_service_ip_restriction_frontdoor.azurerm_app_service_ip_restriction 
}