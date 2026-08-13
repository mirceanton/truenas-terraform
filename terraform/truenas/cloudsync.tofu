resource "truenas_cloudsync_credentials" "backblaze_b2" {
  name = "Backblaze B2"

  b2 {
    account = var.b2_backup_account
    key     = var.b2_backup_key
  }
}

import {
  to = truenas_cloudsync_credentials.backblaze_b2
  id = "2"
}
