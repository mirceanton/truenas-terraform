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

variable "onepassword_vault_name" {
  description = "1Password vault holding each user's Login item (see var.users)"
  type        = string
}

variable "groups" {
  description = "LLDAP group display names to manage"
  type        = set(string)
  default     = []
}

variable "users" {
  description = <<-EOT
    LLDAP users to manage, keyed by username. Each user's groups must reference a name present
    in var.groups.

    onepassword_item_title is the title of a Login-category item in var.onepassword_vault_name.
    Its password becomes the LDAP password. Login items have no built-in email/name fields, so
    the item must also have a custom section labeled exactly "Identity" containing three STRING
    fields labeled "email", "first_name", and "last_name" - these become the LDAP
    email/first_name/last_name (display_name is derived as "first_name last_name").
  EOT
  type = map(object({
    onepassword_item_title = string
    groups                 = optional(set(string), [])
  }))
  default = {}
}
