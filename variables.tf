
# Multiple Validation: https://learn.hashicorp.com/tutorials/terraform/variables#validate-variables

variable "attributes" {
  type = object({
    resource_group_name = string

    // Azure CDN Frontdoor
    profile_id    = string
    profile_name  = string
    endpoint_name = string

    origin_group = object({
      session_affinity_enabled = optional(bool, false),
      load_balancing = optional(object({
        sample_size                 = optional(number, 4),
        successful_samples_required = optional(number, 3)
        }), {
        sample_size                 = 4,
        successful_samples_required = 3
      }),
    })
    health_probe = object({
      path                = optional(string, "/"),
      request_type        = optional(string, "HEAD"),
      protocol            = optional(string, "Https"),
      interval_in_seconds = optional(number, 100)
    })

    # Route Settings
    route = optional(object({
      enabled                = optional(bool, true)
      supported_protocols    = optional(list(string), ["Http", "Https"])
      patterns_to_match      = optional(list(string), ["/*"])
      forwarding_protocol    = optional(string, "HttpsOnly")
      link_to_default_domain = optional(bool, true)
      https_redirect_enabled = optional(bool, true)
      }), {
      supported_protocols    = ["Http", "Https"]
      patterns_to_match      = ["/*"]
      forwarding_protocol    = "HttpsOnly"
      link_to_default_domain = true
      https_redirect_enabled = true
    })

    custom_domain = optional(object({
      enable    = optional(bool, true)
      host_name = string
      tls = optional(object({
        certificate_type    = optional(string, "ManagedCertificate")
        minimum_tls_version = optional(string, "TLS12")
        }), {
        certificate_type    = "ManagedCertificate"
        minimum_tls_version = "TLS12"
      })
    }))

    origin_config = map(
      object({
        enabled                        = optional(bool)
        host_name                      = string
        origin_host_header             = optional(string)
        certificate_name_check_enabled = optional(bool)
        http_port                      = optional(number)
        https_port                     = optional(number)
        priority                       = optional(number)
        weight                         = optional(number)
      })
    )

  })
}
