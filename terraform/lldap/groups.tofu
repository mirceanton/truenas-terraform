resource "lldap_group" "this" {
  for_each = var.groups

  display_name = each.value
}
