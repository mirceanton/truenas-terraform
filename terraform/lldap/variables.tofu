variable "lldap_http_url" {
  description = "LLDAP HTTP admin API URL"
  type        = string
}

variable "lldap_ldap_url" {
  description = "LLDAP LDAP protocol URL"
  type        = string
}

variable "lldap_base_dn" {
  description = "LLDAP base DN"
  type        = string
}

variable "lldap_password" {
  description = "LLDAP admin password"
  type        = string
  sensitive   = true
}

variable "groups" {
  description = "LLDAP group display names to manage"
  type        = set(string)
  default     = []
}

variable "users" {
  description = "LLDAP users to manage, keyed by username. Each user's groups must reference a name present in var.groups."
  type = map(object({
    email        = string
    display_name = optional(string)
    first_name   = optional(string)
    last_name    = optional(string)
    groups       = optional(set(string), [])
  }))
  default = {}
}
