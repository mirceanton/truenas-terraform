locals {
  b2_backup_bucket = "mirceanton-truenas-backup"

  b2_backup_schedule = {
    minute = "0"
    hour   = "0"
    dom    = "*"
    month  = "*"
    dow    = "*"
  }

  # `id` is the live cloud sync task id, used only by the import blocks in
  # imports.tofu; `description` is both the map key and the task description
  # (cloud sync tasks have no separate name field).
  cloud_sync_tasks = {
    "B2 - Users - Mircea"         = { id = 10, path = "/mnt/tank/Users/mircea", folder = "/Users/mircea" }
    "B2 - Users - Bianca"         = { id = 11, path = "/mnt/tank/Users/bianca", folder = "/Users/bianca" }
    "B2 - Projects - mirceanton"  = { id = 12, path = "/mnt/tank/Projects/mirceanton", folder = "/Projects/mirceanton" }
    "B2 - Projects - bomkii"      = { id = 13, path = "/mnt/tank/Projects/bomkii", folder = "/Projects/bomkii" }
    "B2 - Projects - BehindGates" = { id = 14, path = "/mnt/tank/Projects/BehindGates", folder = "/Projects/BehindGates" }
    "B2 - Apps" = {
      id       = 17
      path     = "/mnt/tank/Apps"
      folder   = "/Apps"
      snapshot = false
      exclude  = ["Torrent_Downloads"]
    }
  }
}

# Attribute names and enum casing both changed with the official provider:
# the B2 bucket/folder moved from a `b2 { … }` block into the `attributes` JSON
# document, `direction`/`transfer_mode` are UPPERCASE, `credentials` is already
# a number (no tonumber()), and the client-side encryption settings became a
# flat boolean plus write-only `encryption_password`/`encryption_salt`.
resource "truenas_cloudsync_task" "this" {
  for_each = local.cloud_sync_tasks

  description   = each.key
  path          = each.value.path
  credentials   = truenas_cloudsync_credentials.backblaze_b2.id
  direction     = "PUSH"
  transfer_mode = "SYNC"
  transfers     = 16
  snapshot      = try(each.value.snapshot, true)
  exclude       = try(each.value.exclude, null)

  # `attributes` is sent verbatim and compared verbatim against what the API
  # returns. TrueNAS persists the B2 provider's own defaults alongside what is
  # sent (chunk_size 96 MiB, fast_list off) - every live task carries them - so
  # they are declared here too. Without them the first plan after the import
  # re-proposes all six tasks just to drop the two API-added keys.
  attributes = jsonencode({
    bucket     = local.b2_backup_bucket
    chunk_size = 96
    fast_list  = false
    folder     = each.value.folder
  })

  encryption          = true
  encryption_password = var.b2_backup_encryption_password
  encryption_salt     = var.b2_backup_encryption_salt

  schedule = {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }
}
