resource "lldap_user" "this" {
  for_each = var.users

  username     = each.key
  email        = each.value.email
  display_name = each.value.display_name
  first_name   = each.value.first_name
  last_name    = each.value.last_name
}

resource "lldap_user_memberships" "this" {
  for_each = { for username, user in var.users : username => user.groups if length(user.groups) > 0 }

  user_id   = lldap_user.this[each.key].id
  group_ids = toset([for group_name in each.value : lldap_group.this[group_name].id])
}
