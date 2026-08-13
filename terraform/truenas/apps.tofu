resource "truenas_app" "traefik" {
  name       = "traefik"
  custom_app = true
  compose_config = templatefile("${path.module}/files/traefik/compose.yaml", {
    TRAEFIK_CF_DNS_API_TOKEN     = replace(var.traefik_cf_dns_api_token, "$", "$$")
    TRAEFIK_DASHBOARD_BASIC_AUTH = replace(var.traefik_dashboard_basic_auth, "$", "$$")
  })
}

resource "truenas_app" "dozzle" {
  name       = "dozzle"
  custom_app = true
  compose_config = templatefile("${path.module}/files/dozzle/compose.yaml", {
    DOZZLE_ADMIN_USERNAME = replace(var.dozzle_admin_username, "$", "$$")
    DOZZLE_ADMIN_PASSWORD = replace(var.dozzle_admin_password, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "exporters" {
  name           = "exporters"
  custom_app     = true
  compose_config = file("${path.module}/files/exporters/compose.yaml")
}

resource "truenas_app" "garage" {
  name       = "garage"
  custom_app = true
  compose_config = templatefile("${path.module}/files/garage/compose.yml", {
    garage_config           = indent(6, file("${path.module}/files/garage/garage.toml"))
    GARAGE_RPC_SECRET       = replace(var.garage_rpc_secret, "$", "$$")
    GARAGE_ADMIN_TOKEN      = replace(var.garage_admin_token, "$", "$$")
    GARAGE_WEBUI_ADMIN_PASS = replace(var.garage_webui_admin_pass, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "keycloak" {
  name       = "keycloak"
  custom_app = true
  compose_config = templatefile("${path.module}/files/keycloak/compose.yaml", {
    KEYCLOAK_ADMIN_USERNAME = replace(var.keycloak_admin_username, "$", "$$")
    KEYCLOAK_ADMIN_PASSWORD = replace(var.keycloak_admin_password, "$", "$$")
    KEYCLOAK_DB_PASSWORD    = replace(var.keycloak_db_password, "$", "$$")
    LLDAP_JWT_SECRET        = replace(var.lldap_jwt_secret, "$", "$$")
    LLDAP_ADMIN_PASSWORD    = replace(var.lldap_admin_password, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "nexus" {
  name           = "registry"
  custom_app     = true
  compose_config = file("${path.module}/files/registry/compose.yaml")
  depends_on     = [truenas_app.traefik]
}
