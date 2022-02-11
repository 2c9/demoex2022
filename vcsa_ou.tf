resource "vsphere_resource_pool" "tf_pool" {
  name                    = format("${var.prefix}DEMO2022-C${var.index}")
  parent_resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  #tags = ["${vsphere_tag.students[count.index].id}"]
}

resource "vsphere_folder" "folder" {
  path          = format("${var.prefix}DEMO2022-C${var.index}")
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
  #tags = ["${vsphere_tag.students[count.index].id}"]
}
