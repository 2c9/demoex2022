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

data "vsphere_role" "role" {
  label = "DEMOEX2022"
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