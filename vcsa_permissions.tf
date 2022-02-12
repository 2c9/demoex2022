resource "vsphere_entity_permissions" "perms" {
  entity_id   = vsphere_resource_pool.tf_pool.id
  entity_type = "ResourcePool"
  permissions {
    user_or_group = "${var.domain}\\${var.student}"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.role.id
  }
}

resource "vsphere_entity_permissions" "folder_perms" {
  entity_id   = vsphere_folder.folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = "${var.domain}\\${var.student}"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.role.id
  }
}

resource "null_resource" "network_permissions" {
  depends_on = [
    data.vsphere_network.network_isp_cli,
    data.vsphere_network.network_isp_rtrl,
    data.vsphere_network.network_isp_rtrr,
    data.vsphere_network.network_rtrl,
    data.vsphere_network.network_rtrr
  ]
  provisioner "local-exec" {
    environment = {
        username = var.student
        domain = var.domain
    }
    command = "pwsh ./helpers/setperms.ps1"
    when = create
  }
}

# resource "vsphere_entity_permissions" "network_isp_cli" {
#   entity_id   = data.vsphere_network.network_isp_cli.id
#   entity_type = "DistributedVirtualPortgroup"
#   permissions {
#     user_or_group = "${var.domain}\\${var.student}"
#     propagate = false
#     is_group = false
#     role_id = data.vsphere_role.role.id
#   }
# }

# resource "vsphere_entity_permissions" "network_isp_rtrl" {
#   entity_id   = data.vsphere_network.network_isp_rtrl.id
#   entity_type = "DistributedVirtualPortgroup"
#   permissions {
#     user_or_group = "${var.domain}\\${var.student}"
#     propagate = false
#     is_group = false
#     role_id = data.vsphere_role.role.id
#   }
# }