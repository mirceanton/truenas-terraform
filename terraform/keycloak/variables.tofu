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
  description = "Keycloak realm to create; the admin user is scoped to administer only it"
  type        = string
}

variable "realm_display_name" {
  description = "Display name for var.realm_id"
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Username for the master-realm admin account scoped to var.realm_id"
  type        = string
}

variable "admin_password_rotation_days" {
  description = "How often to rotate the realm admin account's password"
  type        = number
  default     = 90
}

variable "admin_realm_management_roles" {
  description = "Delegated-admin roles (from master's \"<realm_id>-realm\" client, scoped to var.realm_id) granted to the admin account"
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
