variable "keycloak_url" {
  description = "Keycloak base URL"
  type        = string
}

variable "keycloak_admin_username" {
  description = "Keycloak bootstrap admin username (master realm), used to authenticate the provider"
  type        = string
}

variable "keycloak_admin_password" {
  description = "Keycloak bootstrap admin password, used to authenticate the provider"
  type        = string
  sensitive   = true
}

variable "operator_username" {
  description = "Username for the admin-level operator user to create in the master realm"
  type        = string
  default     = "keycloak-operator"
}

variable "operator_password" {
  description = "Password for the operator user"
  type        = string
  sensitive   = true
}
