# iSCSI: one target chain exporting the Steam-library ZVOL to the Talos node.
#
# Order matters — portal and initiator must exist before the target that
# references them, the target and the extent before the LUN mapping.
locals {
  iscsi_portals = {
    "STORAGE" = { id = 3, ip = "10.255.255.245" }
    "TRUSTED" = { id = 4, ip = "192.168.69.245" }
  }
}

resource "truenas_iscsi_global" "this" {
  basename    = "iqn.2005-10.org.freenas.ctl"
  listen_port = 3260
}

resource "truenas_iscsi_portal" "this" {
  for_each = local.iscsi_portals

  comment = each.key

  # TrueNAS rejects a listen address that is not statically configured on the
  # box (a DHCP-held address cannot be used here).
  listen = [{ ip = each.value.ip, port = 3260 }]
}

resource "truenas_iscsi_initiator" "talos" {
  comment    = "Talos"
  initiators = ["iqn.2017-11.dev.talos:cfac9bff83c2df697e95c5d4ad3e8392"]
}

resource "truenas_iscsi_target" "steamlib" {
  name = "mircea-steamlib"
  mode = "ISCSI"

  groups = [{
    portal     = truenas_iscsi_portal.this["STORAGE"].id
    initiator  = truenas_iscsi_initiator.talos.id
    authmethod = "NONE"
  }]
}

resource "truenas_iscsi_extent" "steamlib" {
  name         = "mircea-steamlib"
  type         = "DISK"
  disk         = "zvol/${truenas_zvol.steamlib.name}"
  enabled      = true
  blocksize    = 4096
  insecure_tpc = true
  rpm          = "SSD"
}

resource "truenas_iscsi_targetextent" "steamlib" {
  target = truenas_iscsi_target.steamlib.id
  extent = truenas_iscsi_extent.steamlib.id
  lunid  = 0
}