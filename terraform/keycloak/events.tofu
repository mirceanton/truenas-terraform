variable "events_expiration" {
  description = "How long, in seconds, realm events are kept in the database (0 keeps them forever)"
  type        = number
  default     = 7776000 # 90 days
}

# Persist authentication events (LOGIN, CODE_TO_TOKEN, ...) and admin events in the
# Keycloak database, so "who authenticated, from which address, through which
# client" can still be answered after the container log has rotated. Stored events
# are exposed by the admin console and by /admin/realms/<realm>/events.
#
# enabled_event_types is deliberately left unset - unset stores every event type, so
# a later audit does not hit a blind spot from a type nobody thought to list.
# jboss-logging has to be named explicitly, because the provider clears the realm's
# default listener when events_listeners is not set, which would silence the
# container log.
resource "keycloak_realm_events" "this" {
  realm_id = keycloak_realm.this.id

  events_enabled    = true
  events_expiration = var.events_expiration

  admin_events_enabled         = true
  admin_events_details_enabled = true

  events_listeners = ["jboss-logging"]
}
