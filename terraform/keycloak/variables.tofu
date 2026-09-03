variable "keycloak_url" {
  description = "Keycloak base URL"
  type        = string
}

variable "keycloak_username" {
  description = "Keycloak admin username"
  type        = string
}

variable "keycloak_password" {
  description = "Keycloak admin password"
  type        = string
  sensitive   = true
}

variable "realms" {
  description = "Keycloak realms to manage, keyed by stable logical name (used as the realm ID)"
  type = map(object({
    display_name = optional(string)
    enabled      = optional(bool, true)
  }))
  default = {}
}

variable "groups" {
  description = "Keycloak groups to manage, keyed by stable logical name. realm must reference a name present in var.realms."
  type = map(object({
    realm = string
    name  = string
  }))
  default = {}
}

variable "clients" {
  description = "Keycloak OpenID Connect clients to manage, keyed by stable logical name. realm must reference a name present in var.realms."
  type = map(object({
    realm                           = string
    client_id                       = string
    enabled                         = optional(bool, true)
    access_type                     = optional(string, "CONFIDENTIAL")
    standard_flow_enabled           = optional(bool, true)
    direct_access_grants_enabled    = optional(bool, false)
    valid_redirect_uris             = optional(list(string), [])
    valid_post_logout_redirect_uris = optional(list(string), [])
    web_origins                     = optional(list(string), [])
  }))
  default = {}
}
