# Scrub schedules. TrueNAS keeps exactly one scrub schedule *per pool* — this
# is not a per-dataset object, so the pool id from the data source is the
# reference to use. `id` is the live scrub schedule id, used only by the
# import blocks in imports.tofu.
locals {
  scrub_schedules = {
    tank    = { id = 6, pool = data.truenas_pool.this["tank"].id }
    scratch = { id = 7, pool = data.truenas_pool.this["scratch"].id }
  }
}

resource "truenas_scrub_task" "this" {
  for_each = local.scrub_schedules

  pool      = each.value.pool
  threshold = 35
  enabled   = true

  schedule = {
    minute = "00"
    hour   = "00"
    dom    = "*"
    month  = "*"
    dow    = "7" # Sunday
  }
}