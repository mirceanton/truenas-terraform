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

variable "realm_id" {
  description = "Keycloak realm to create; the operator user is created in it and scoped to administer only it"
  type        = string
}

variable "realm_display_name" {
  description = "Display name for var.realm_id"
  type        = string
  default     = null
}

variable "operator_username" {
  description = "Username for the Keycloak operator service account"
  type        = string
  default     = "keycloak-operator"
}

variable "operator_realm_management_roles" {
  description = "realm-management client roles (scoped to var.realm_id, not master) granted to the operator user"
  type        = set(string)
  default = [
    "manage-realm",
    "manage-clients",
    "manage-users",
    "create-client",
    "view-realm",
    "view-clients",
    "view-users",
    "query-clients",
    "query-users",
    "query-groups",
  ]
}
