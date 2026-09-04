# Federates var.realm_id's users and groups from LLDAP. LLDAP is read-only from Keycloak's side:
# users/groups are managed in LLDAP (see terraform/lldap) and only flow one way into Keycloak.
resource "keycloak_ldap_user_federation" "lldap" {
  realm_id = keycloak_realm.this.id
  name     = "lldap"

  enabled   = true
  edit_mode = "READ_ONLY"
  vendor    = "OTHER"

  connection_url  = var.ldap_url
  users_dn        = "ou=people,${var.ldap_base_dn}"
  bind_dn         = "uid=${var.ldap_bind_username},ou=people,${var.ldap_base_dn}"
  bind_credential = var.ldap_bind_password

  username_ldap_attribute = "uid"
  rdn_ldap_attribute      = "uid"
  uuid_ldap_attribute     = "uid"
  user_object_classes     = ["person"]

  use_password_modify_extended_op = true
  pagination                      = false

  # Keycloak auto-creates its own default mappers (matching LLDAP's "cn" display-name attribute
  # to first name, causing duplicated/missing names) as part of provider creation; delete them so
  # the explicit mappers below - which point at LLDAP's actual attributes - are the only ones.
  delete_default_mappers = true
}

resource "keycloak_ldap_group_mapper" "lldap" {
  realm_id                = keycloak_realm.this.id
  ldap_user_federation_id = keycloak_ldap_user_federation.lldap.id
  name                    = "groups"

  ldap_groups_dn                 = "ou=groups,${var.ldap_base_dn}"
  group_name_ldap_attribute      = "cn"
  group_object_classes           = ["groupOfUniqueNames"]
  membership_attribute_type      = "DN"
  membership_ldap_attribute      = "uniqueMember"
  membership_user_ldap_attribute = "uid"
  mode                           = "READ_ONLY"
}

resource "keycloak_ldap_user_attribute_mapper" "username" {
  realm_id                = keycloak_realm.this.id
  ldap_user_federation_id = keycloak_ldap_user_federation.lldap.id
  name                    = "username"

  user_model_attribute = "username"
  ldap_attribute       = "uid"
  is_mandatory_in_ldap = true
}

resource "keycloak_ldap_user_attribute_mapper" "email" {
  realm_id                = keycloak_realm.this.id
  ldap_user_federation_id = keycloak_ldap_user_federation.lldap.id
  name                    = "email"

  user_model_attribute = "email"
  ldap_attribute       = "mail"
}

resource "keycloak_ldap_user_attribute_mapper" "first_name" {
  realm_id                = keycloak_realm.this.id
  ldap_user_federation_id = keycloak_ldap_user_federation.lldap.id
  name                    = "first name"

  user_model_attribute = "firstName"
  ldap_attribute       = "givenName"
}

resource "keycloak_ldap_user_attribute_mapper" "last_name" {
  realm_id                = keycloak_realm.this.id
  ldap_user_federation_id = keycloak_ldap_user_federation.lldap.id
  name                    = "last name"

  user_model_attribute = "lastName"
  ldap_attribute       = "sn"
}
