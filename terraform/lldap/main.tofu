resource "lldap_group" "this" {
  for_each = var.groups

  display_name = each.value
}

data "onepassword_vault" "this" {
  name = var.onepassword_vault_name
}

# Each user's Login item supplies the password natively, plus email/first_name/last_name as
# custom STRING fields in a section labeled "Identity" - 1Password's Login category has no
# built-in fields for those. See var.users' description for the exact item shape expected.
data "onepassword_item" "user" {
  for_each = var.users

  vault = data.onepassword_vault.this.uuid
  title = each.value.onepassword_item_title
}

locals {
  user_identities = {
    for username, item in data.onepassword_item.user : username => item.section_map["Identity"].field_map
  }
}

resource "lldap_user" "this" {
  for_each = var.users

  username     = each.key
  email        = local.user_identities[each.key]["email"].value
  first_name   = local.user_identities[each.key]["first_name"].value
  last_name    = local.user_identities[each.key]["last_name"].value
  display_name = "${local.user_identities[each.key]["first_name"].value} ${local.user_identities[each.key]["last_name"].value}"
  password     = data.onepassword_item.user[each.key].password
}

resource "lldap_user_memberships" "this" {
  for_each = { for username, user in var.users : username => user.groups if length(user.groups) > 0 }

  user_id   = lldap_user.this[each.key].id
  group_ids = toset([for group_name in each.value : lldap_group.this[group_name].id])
}
