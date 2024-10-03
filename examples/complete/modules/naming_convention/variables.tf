variable "hostname_protocol" {
  default = "https"
  type    = string
  validation {
    condition     = var.hostname_protocol == "https" || var.hostname_protocol == "http"
    error_message = "Unsupport protocol."
  }
}

variable "seperator" {
  default = "-"
}

variable "seperator_short" {
  default = ""
}

# Multiple Validation: https://learn.hashicorp.com/tutorials/terraform/variables#validate-variables

variable "attributes" {
  type = object({
    name                        = string
    type                        = string
    org                         = string
    project                     = string
    project_short               = string
    environment                 = string
    environment_short           = string
    scope                       = string
    scope_short                 = string #only storage account
    scope_shortest              = string #all resource except storage account 
    domain                      = optional(string)
  })
  validation {
    condition     = (
      var.attributes.type == "resource_group" || 
      var.attributes.type == "function_app" || 
      var.attributes.type == "app_service" || 
      var.attributes.type == "app_service_plan" || 
      var.attributes.type == "app_service_plan_short" || 
      var.attributes.type == "mssql_server" || 
      var.attributes.type == "storage_account" || 
      var.attributes.type == "storage_account_short" || 
      var.attributes.type == "storage_account_file_shares" || 
      var.attributes.type == "log_analytics_workspace" || 
      var.attributes.type == "container_group" || 
      var.attributes.type == "static" || 
      var.attributes.type == "static_app_service" || 
      var.attributes.type == "static_mssql_server" || 
      var.attributes.type == "container_app_environment" || 
      var.attributes.type == "container_app" || 
      var.attributes.type == "logic_app" ||
      var.attributes.type == "cdn_profile" ||
      var.attributes.type == "container_registry" ||
      var.attributes.type == "signalr" ||
      var.attributes.type == "mongo" ||
      var.attributes.type == "cdn_frontdoor" ||
      var.attributes.type == "cdn_frontdoor_firewall_policy" ||
      var.attributes.type == "cdn_frontdoor_security_policy" ||
      var.attributes.type == "cdn_frontdoor_endpoint" ||
      var.attributes.type == "function_app_host_id_setting" ||
      var.attributes.type == "key_vault" ||
      var.attributes.type == "key_vault_identity"
    )
    error_message = "Unsupport resource types."
  }
}
