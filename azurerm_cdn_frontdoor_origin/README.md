# How to move state from root module to this module

Ref: https://www.terraform.io/cli/commands/state/mv#example-move-a-resource-configured-with-for_each

```
terraform state mv 'azurerm_app_service_custom_hostname_binding.utility_ng_api' 'module.domain_binding["utility_ng_api"].azurerm_app_service_custom_hostname_binding.default'

terraform state mv 'azurerm_app_service_certificate_binding.utility_ng_api' 'module.domain_binding["utility_ng_api"].azurerm_app_service_certificate_binding.default'

terraform state mv 'azurerm_app_service_managed_certificate.utility_ng_api' 'module.domain_binding["utility_ng_api"].azurerm_app_service_managed_certificate.default'
```