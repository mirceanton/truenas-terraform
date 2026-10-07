# Adopting the objects that already exist on the NAS.
#
# The provider swap drops the old deevus/truenas state (different provider
# type, incompatible schema), so every object this configuration manages is
# brought back under Terraform with an import block instead of being created.
# Imports are evaluated on plan, so the first `plan` after this PR reads the
# live objects and compares them with the configuration below: with a matching
# configuration the plan is empty.
#
# Import ids were read from the provider's ImportState implementations (most of
# them are not documented):
#   dataset / zvol                      -> the dataset path
#   snapshot task / scrub task          -> numeric id
#   smb share                           -> numeric id
#   nfs share                           -> numeric id as a string
#   cloud sync task / credentials       -> numeric id
#   iSCSI portal/initiator/target/…     -> numeric id
#   app / service                       -> name
#   smb_config / nfs_config / iscsi_global -> fixed singleton id (any id is
#     accepted and normalised)
#
# These blocks are harmless once the objects are in state (OpenTofu reports no
# change) and can simply be deleted afterwards — the ids they need live in the
# locals of the files that declare the resources.

import {
  for_each = local.datasets
  to       = truenas_dataset.this[each.key]
  id       = each.key
}

import {
  to = truenas_zvol.steamlib
  id = "tank/ZVOLs/mircea-steamlib"
}

import {
  for_each = local.periodic_snapshots
  to       = truenas_periodic_snapshot_task.this[each.key]
  id       = tostring(each.value.id)
}

import {
  for_each = local.scrub_schedules
  to       = truenas_scrub_task.this[each.key]
  id       = tostring(each.value.id)
}

import {
  for_each = local.smb_shares
  to       = truenas_smb_share.this[each.key]
  id       = tostring(each.value.id)
}

import {
  for_each = local.nfs_shares
  to       = truenas_nfs_share.this[each.key]
  id       = tostring(each.value.id)
}

import {
  to = truenas_smb_config.this
  id = "smb_config"
}

import {
  to = truenas_nfs_config.this
  id = "nfs_config"
}

import {
  to = truenas_iscsi_global.this
  id = "iscsi_global"
}

import {
  for_each = local.iscsi_portals
  to       = truenas_iscsi_portal.this[each.key]
  id       = tostring(each.value.id)
}

import {
  to = truenas_iscsi_initiator.talos
  id = "11"
}

import {
  to = truenas_iscsi_target.steamlib
  id = "11"
}

import {
  to = truenas_iscsi_extent.steamlib
  id = "11"
}

import {
  to = truenas_iscsi_targetextent.steamlib
  id = "11"
}

import {
  for_each = local.services
  to       = truenas_service.this[each.key]
  id       = each.key
}

# Custom apps (compose-based). Import id is the app name.
import {
  to = truenas_app.traefik
  id = "traefik"
}

import {
  to = truenas_app.dozzle
  id = "dozzle"
}

import {
  to = truenas_app.exporters
  id = "exporters"
}

import {
  to = truenas_app.garage
  id = "garage"
}

import {
  to = truenas_app.keycloak
  id = "keycloak"
}

import {
  to = truenas_app.nexus
  id = "registry"
}

import {
  to = truenas_app.zot
  id = "zot"
}

import {
  to = truenas_cloudsync_credentials.backblaze_b2
  id = "2"
}

import {
  for_each = local.cloud_sync_tasks
  to       = truenas_cloudsync_task.this[each.key]
  id       = tostring(each.value.id)
}