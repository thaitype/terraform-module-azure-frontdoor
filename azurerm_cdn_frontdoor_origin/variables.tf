
# Multiple Validation: https://learn.hashicorp.com/tutorials/terraform/variables#validate-variables

variable "attributes" {
  type = object({
    endpoint_name   = string
    origin_group_id = string
    // Endpoint Name
    name = string

    # Origin Settings
    origin = object({
      enabled                        = optional(bool, true)
      host_name                      = string
      origin_host_header             = optional(string)
      certificate_name_check_enabled = optional(bool, true)
      http_port                      = optional(number, 80)
      https_port                     = optional(number, 443)
      priority                       = optional(number, 1)
      weight                         = optional(number, 1000)
    })

  })
}
