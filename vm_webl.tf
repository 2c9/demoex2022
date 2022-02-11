resource "vsphere_virtual_machine" "webl" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    name             = format("${var.prefix}WEB-L-${var.index}")
    folder           = vsphere_folder.folder.path
    resource_pool_id = vsphere_resource_pool.tf_pool.id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrl.id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.debian_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.debian_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.debian_template.disks.0.thin_provisioned
    }

    cdrom {
        datastore_id = "${data.vsphere_datastore.nfs.id}"
        path         = "demoex/debian-11.2.0-amd64-BD-1.iso"
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.debian_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${data.vsphere_tag.debian11.id}", "${data.vsphere_tag.web-l.id}"]
}