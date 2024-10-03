locals {

  app_service_template = "%s%s-%s-%s-%s" # org, project, env, scope, name

  parsed_scope          = replace(var.attributes.scope, "_", "-")                                                          # For URL support
  parsed_scope_short    = replace(replace(var.attributes.scope_short, "_", var.seperator_short), "-", var.seperator_short) # For URL support
  parsed_scope_shortest = replace(replace(var.attributes.scope_shortest, "_", var.seperator_short), "-", var.seperator_short)
  parsed_name           = replace(var.attributes.name, "_", "-")       # For URL support
  parsed_env            = replace(var.attributes.environment, "-", "") # for storage account
  org_with_project      = format("%s%s", var.attributes.org, var.attributes.project)

  environment_short = var.attributes.environment_short == null ? "" : var.attributes.environment_short
  parsed_env_short  = replace(local.environment_short, "-", "")

  resource_types = {
    static                    = local.parsed_name
    static_app_service        = local.parsed_name
    static_mssql_server       = local.parsed_name
    resource_group            = trimsuffix(join(var.seperator, ["rg", var.attributes.project, var.attributes.environment, local.parsed_scope]), var.seperator)
    storage_account           = trimsuffix(join(var.seperator_short, [var.attributes.project_short, "data", local.parsed_env, local.parsed_scope_short, local.parsed_name]), var.seperator_short)
    storage_account_short     = trimsuffix(join(var.seperator_short, [var.attributes.project_short, local.parsed_env_short, local.parsed_scope_short, local.parsed_name]), var.seperator_short)
    storage_account_file_shares = trimsuffix(join(var.seperator_short, [local.parsed_env_short, local.parsed_scope_short, local.parsed_name]), var.seperator_short)
    log_analytics_workspace   = trimsuffix(join(var.seperator, [local.org_with_project, "loganalyticsworkspace", var.attributes.environment, local.parsed_scope, local.parsed_name]), var.seperator_short)
    container_app_environment = trimsuffix(join(var.seperator, ["wrmstorm", var.attributes.environment, local.parsed_scope, "container-env"]), var.seperator)
    container_app             = trimsuffix(join(var.seperator, [var.attributes.project_short, var.attributes.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
    logic_app                 = trimsuffix(join(var.seperator, [var.attributes.project_short, local.environment_short, local.parsed_scope_short, local.parsed_name]), var.seperator)
    container_registry        = trimsuffix(join(var.seperator_short, [var.attributes.project_short, local.parsed_env, local.parsed_scope_short, local.parsed_name]), var.seperator_short)
    cdn_profile               = trimsuffix(join(var.seperator, [var.attributes.project_short, local.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
    signalr                   = trimsuffix(join(var.seperator, [var.attributes.project_short, var.attributes.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
    mongo                     = trimsuffix(join(var.seperator, [var.attributes.project_short, var.attributes.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
    key_vault                 = trimsuffix(join(var.seperator, ["kv", var.attributes.project_short, var.attributes.environment, local.parsed_scope]), var.seperator)
    key_vault_identity        = trimsuffix(join(var.seperator, ["id", var.attributes.project_short, var.attributes.environment, local.parsed_scope]), var.seperator)

    # App Service Plan
    app_service_plan       = trimsuffix(join(var.seperator, ["ap", var.attributes.project, var.attributes.environment, local.parsed_scope, local.parsed_name]), var.seperator)
    app_service_plan_short = trimsuffix(join(var.seperator, ["ap", var.attributes.project, local.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)

    # Azure Container Instances Group   
    container_group = trimsuffix(join(var.seperator, [local.org_with_project, var.attributes.environment, local.parsed_scope, local.parsed_name, "ci"]), var.seperator)

    # Same naming Convention
    app_service  = trimsuffix(join(var.seperator, [local.org_with_project, var.attributes.environment, local.parsed_scope, local.parsed_name]), var.seperator)
    function_app = trimsuffix(join(var.seperator, [local.org_with_project, var.attributes.environment, local.parsed_scope, local.parsed_name]), var.seperator)
    mssql_server = trimsuffix(join(var.seperator, [local.org_with_project, var.attributes.environment, local.parsed_scope, local.parsed_name]), var.seperator)

    # Front Door & WAF
    cdn_frontdoor                   = trimsuffix(join(var.seperator, [var.attributes.project_short, var.attributes.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
    cdn_frontdoor_firewall_policy   = trimsuffix(join(var.seperator_short, [var.attributes.project_short, local.parsed_env_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator_short)
    cdn_frontdoor_security_policy   = trimsuffix(join(var.seperator, [var.attributes.project_short, var.attributes.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
    cdn_frontdoor_endpoint          = trimsuffix(join(var.seperator_short, [var.attributes.project_short, local.parsed_env_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator_short)

    # App Setting HostId
    function_app_host_id_setting  = trimsuffix(join(var.seperator, [var.attributes.project_short, var.attributes.environment_short, local.parsed_scope_shortest, local.parsed_name]), var.seperator)
  }

  hostnames = {
    app_service  = "${local.resource_types.app_service}.azurewebsites.net"
    function_app = "${local.resource_types.function_app}.azurewebsites.net"
    mssql_server = "${local.resource_types.mssql_server}.database.windows.net"

    static_app_service  = "${local.resource_types.static_app_service}.azurewebsites.net"
    static_mssql_server = "${local.resource_types.static_mssql_server}.azurewebsites.net"
  }
  urls = {
    function_app       = "${var.hostname_protocol}://${local.hostnames.function_app}"
    app_service        = "${var.hostname_protocol}://${local.hostnames.app_service}"
    static_app_service = "${var.hostname_protocol}://${local.hostnames.static_app_service}"
  }

  # Output 
  name             = lookup(local.resource_types, var.attributes.type, "something-wrong??")
  default_hostname = lookup(local.hostnames, var.attributes.type, "")
  url              = lookup(local.urls, var.attributes.type, "")
}
