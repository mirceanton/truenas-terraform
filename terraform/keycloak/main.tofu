resource "keycloak_realm" "this" {
  for_each = var.realms

  realm        = each.key
  display_name = each.value.display_name
  enabled      = each.value.enabled
}

resource "keycloak_group" "this" {
  for_each = var.groups

  realm_id = keycloak_realm.this[each.value.realm].id
  name     = each.value.name
}

resource "keycloak_openid_client" "this" {
  for_each = var.clients

  realm_id                        = keycloak_realm.this[each.value.realm].id
  client_id                       = each.value.client_id
  enabled                         = each.value.enabled
  access_type                     = each.value.access_type
  standard_flow_enabled           = each.value.standard_flow_enabled
  direct_access_grants_enabled    = each.value.direct_access_grants_enabled
  valid_redirect_uris             = each.value.valid_redirect_uris
  valid_post_logout_redirect_uris = each.value.valid_post_logout_redirect_uris
  web_origins                     = each.value.web_origins
}
