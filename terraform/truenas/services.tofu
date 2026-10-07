# Sharing services. A share does not enable the service that serves it, so the
# three services the shares and iSCSI rely on are managed explicitly.
locals {
  services = {
    cifs        = true # backs the SMB shares
    nfs         = true # backs the NFS exports
    iscsitarget = true # backs the iSCSI target
  }
}

resource "truenas_service" "this" {
  for_each = local.services

  name    = each.key
  enabled = each.value
  running = each.value
}