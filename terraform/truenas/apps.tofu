resource "random_password" "traefik_dashboard_admin" {
  length  = 32
  special = false
}

resource "truenas_app" "traefik" {
  name       = "traefik"
  custom_app = true
  compose_config = templatefile("${path.module}/files/traefik/compose.yaml", {
    TRAEFIK_CF_DNS_API_TOKEN     = replace(var.traefik_cf_dns_api_token, "$", "$$")
    TRAEFIK_DASHBOARD_BASIC_AUTH = replace("${var.traefik_dashboard_username}:${random_password.traefik_dashboard_admin.bcrypt_hash}", "$", "$$")
  })
}

resource "random_password" "dozzle_admin" {
  length  = 32
  special = false
}

resource "truenas_app" "dozzle" {
  name       = "dozzle"
  custom_app = true
  compose_config = templatefile("${path.module}/files/dozzle/compose.yaml", {
    DOZZLE_ADMIN_USERNAME = replace(var.dozzle_admin_username, "$", "$$")
    DOZZLE_ADMIN_PASSWORD = replace(random_password.dozzle_admin.bcrypt_hash, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "exporters" {
  name           = "exporters"
  custom_app     = true
  compose_config = file("${path.module}/files/exporters/compose.yaml")
}

resource "random_id" "garage_rpc_secret" {
  byte_length = 32
}

resource "random_password" "garage_admin_token" {
  length  = 32
  special = false
}

resource "random_password" "garage_webui_admin" {
  length  = 32
  special = false
}

resource "truenas_app" "garage" {
  name       = "garage"
  custom_app = true
  compose_config = templatefile("${path.module}/files/garage/compose.yml", {
    garage_config = join("\n", [
      for i, line in split("\n", trimsuffix(file("${path.module}/files/garage/garage.toml"), "\n")) :
      i == 0 || line == "" ? line : "            ${line}"
    ])
    GARAGE_RPC_SECRET       = replace(random_id.garage_rpc_secret.hex, "$", "$$")
    GARAGE_ADMIN_TOKEN      = replace(random_password.garage_admin_token.result, "$", "$$")
    GARAGE_WEBUI_ADMIN_PASS = replace("${var.garage_webui_admin_username}:${random_password.garage_webui_admin.bcrypt_hash}", "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "random_password" "keycloak_admin" {
  length  = 32
  special = false
}

resource "random_password" "keycloak_db" {
  length  = 32
  special = false
}

resource "random_password" "keycloak_operator" {
  length  = 32
  special = false
}

resource "random_password" "lldap_jwt_secret" {
  length  = 64
  special = false
}

resource "random_password" "lldap_admin" {
  length  = 32
  special = false
}

resource "truenas_app" "keycloak" {
  name       = "keycloak"
  custom_app = true
  compose_config = templatefile("${path.module}/files/keycloak/compose.yaml", {
    KEYCLOAK_ADMIN_USERNAME = replace(var.keycloak_admin_username, "$", "$$")
    KEYCLOAK_ADMIN_PASSWORD = replace(random_password.keycloak_admin.result, "$", "$$")
    KEYCLOAK_DB_PASSWORD    = replace(random_password.keycloak_db.result, "$", "$$")
    LLDAP_JWT_SECRET        = replace(random_password.lldap_jwt_secret.result, "$", "$$")
    LLDAP_ADMIN_PASSWORD    = replace(random_password.lldap_admin.result, "$", "$$")
    LLDAP_SMTP_USER         = replace(var.lldap_smtp_username, "$", "$$")
    LLDAP_SMTP_PASSWORD     = replace(var.lldap_smtp_password, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "nexus" {
  name           = "registry"
  custom_app     = true
  compose_config = file("${path.module}/files/registry/compose.yaml")
  depends_on     = [truenas_app.traefik]
}

resource "random_password" "zot_admin" {
  length  = 32
  special = false
}

resource "truenas_app" "zot" {
  name       = "zot"
  custom_app = true
  compose_config = templatefile("${path.module}/files/zot/compose.yaml", {
    zot_config = join("\n", [
      for i, line in split("\n", trimsuffix(file("${path.module}/files/zot/config.json"), "\n")) :
      i == 0 || line == "" ? line : "      ${line}"
    ])
    ZOT_HTPASSWD_LINE = replace("admin:${random_password.zot_admin.bcrypt_hash}", "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}
