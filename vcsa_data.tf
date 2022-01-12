data "vsphere_datacenter" "dc" {
  name = "DatacenterDELL"
}

data "vsphere_datastore" "ds" {
  name          = "DELLvsanDatastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "nfs" {
  name          = "NFS"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "ClusterDELL/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_resource_pool" "tf_pool" {
  count                   = var.idx
  name                    = format("TF-DEMO2022-C%s", count.index)
  parent_resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
}

###################################################

data "vsphere_virtual_machine" "debian_template" {
  name          = "debian11-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "winsrv_template" {
  name          = "winsrv2019-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "win10_template" {
  name          = "win10-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "csr1000v_template" {
  name          = "csr1000v-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

###################################################

resource "null_resource" "wait" {
  depends_on = [
      nsxt_policy_segment.tf_isp_cli,
      nsxt_policy_segment.tf_isp_rtrl,
      nsxt_policy_segment.tf_isp_rtrr,
      nsxt_policy_segment.tf_rtrl,
      nsxt_policy_segment.tf_rtrr
  ]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
      command = "sleep 10"
  }
}

###################################################

data "vsphere_network" "network_isp_cli" {
    count      = var.idx
    depends_on = [ null_resource.wait,
                   nsxt_policy_segment.tf_isp_cli ]
    name       = format("TF_ISP_CLI_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_isp_rtrl" {
    depends_on = [ null_resource.wait,
                   nsxt_policy_segment.tf_isp_rtrl ]
    count      = var.idx
    name       = format("TF_ISP_RTR-L_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_isp_rtrr" {
    depends_on = [ null_resource.wait,
                   nsxt_policy_segment.tf_isp_rtrr ]
    count      = var.idx
    name       = format("TF_ISP_RTR-R_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_rtrl" {
    depends_on = [ null_resource.wait,
                   nsxt_policy_segment.tf_rtrl ]
    count      = var.idx
    name       = format("TF_RTR-L_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_rtrr" {
    depends_on = [ null_resource.wait,
                   nsxt_policy_segment.tf_rtrr ]
    count      = var.idx
    name       = format("TF_RTR-R_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}