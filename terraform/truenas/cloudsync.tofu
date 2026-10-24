# One Backblaze B2 credential for all six cloud sync tasks.
#
# The wire field is `provider`; the provider renames it to `provider_config`
# because `provider` is reserved in Terraform. It is a JSON document that must
# carry the `type` discriminator. The application key is *not* part of the
# base document: it goes through the write-only `provider_secrets_wo` overlay,
# which is deep-merged into it when the resource is sent and never written to
# state (Terraform/OpenTofu >= 1.11). Bump `provider_secrets_wo_version` to
# force a re-send after rotating the key.
resource "truenas_cloudsync_credentials" "backblaze_b2" {
  name = "Backblaze B2"

  provider_config = jsonencode({
    type    = "B2"
    account = var.b2_backup_account
  })

  provider_secrets_wo         = jsonencode({ key = var.b2_backup_key })
  provider_secrets_wo_version = 1
}