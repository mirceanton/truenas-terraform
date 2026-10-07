# Periodic snapshot tasks. Retention and the naming schema come from the live
# tasks; the dataset reference (rather than a literal path) keeps the dependency
# edge and picks up the dataset's own path.
locals {
  # `id` is the live snapshot task id and is used only by the import blocks in
  # imports.tofu.
  periodic_snapshots = {
    "tank/Users"    = { id = 33, lifetime_value = 2, lifetime_unit = "WEEK" }
    "tank/Projects" = { id = 34, lifetime_value = 2, lifetime_unit = "WEEK" }
    "tank/Apps"     = { id = 37, lifetime_value = 2, lifetime_unit = "WEEK" }
    "tank/Backups"  = { id = 36, lifetime_value = 7, lifetime_unit = "DAY" }
  }
}

resource "truenas_periodic_snapshot_task" "this" {
  for_each = local.periodic_snapshots

  dataset        = truenas_dataset.this[each.key].name
  recursive      = true
  allow_empty    = true
  enabled        = true
  lifetime_value = each.value.lifetime_value
  lifetime_unit  = each.value.lifetime_unit
  naming_schema  = "auto-%Y-%m-%d_%H-%M"

  schedule = {
    minute = "0"
    hour   = "0"
    dom    = "*"
    month  = "*"
    dow    = "*"
  }
}