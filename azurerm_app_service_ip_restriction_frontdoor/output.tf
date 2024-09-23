output "azurerm_app_service_ip_restriction" {
  value =  [
    {
      action      = "Allow"
      name        = "traffic-allow-frontdoor"
      ip_address  = null
      priority    = 300
      service_tag = "AzureFrontDoor.Backend"
      headers = [
        {
          x_azure_fdid      = []
          x_fd_health_probe = []
          x_forwarded_for   = []
          x_forwarded_host = var.attributes.allow_hostname #Each hostname must have a length of at most 64 characters.
        },
      ]
      virtual_network_subnet_id = null
    },
    {
      action                    = "Deny"
      name                      = "traffic-deny"
      ip_address                = "0.0.0.0/0"
      priority                  = 500
      service_tag               = null
      headers                   = []
      virtual_network_subnet_id = null
    }
  ]
}