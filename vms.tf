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

resource "vsphere_virtual_machine" "isp" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_cli,
      data.vsphere_network.network_isp_rtrl,
      data.vsphere_network.network_isp_rtrr
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-ISP-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_cli[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrr[count.index].id
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

}

############################################################################################

resource "vsphere_virtual_machine" "cli" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_cli
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-CLI-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    firmware = "efi"
    guest_id = data.vsphere_virtual_machine.win10_template.guest_id
    scsi_type = data.vsphere_virtual_machine.win10_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_cli[count.index].id
        adapter_type = data.vsphere_virtual_machine.win10_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.win10_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.win10_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.win10_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.win10_template.id
    }

}

############################################################################################

resource "vsphere_virtual_machine" "rtrl" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-RTR-L-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.csr1000v_template.guest_id
    scsi_type = data.vsphere_virtual_machine.csr1000v_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.csr1000v_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.csr1000v_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.csr1000v_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.csr1000v_template.id
    }

}

############################################################################################

resource "vsphere_virtual_machine" "rtrr" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_rtrr
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-RTR-R-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 8192
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.csr1000v_template.guest_id
    scsi_type = data.vsphere_virtual_machine.csr1000v_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrr[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_rtrr[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.csr1000v_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.csr1000v_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.csr1000v_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.csr1000v_template.id
    }

}

############################################################################################

resource "vsphere_virtual_machine" "webl" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-WEB-L-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrl[count.index].id
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

}

############################################################################################

resource "vsphere_virtual_machine" "webr" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrr
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-WEB-R-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrr[count.index].id
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

}

############################################################################################

resource "vsphere_virtual_machine" "srv" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-SRV-%s", count.index)
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    firmware = "efi"
    guest_id = data.vsphere_virtual_machine.winsrv_template.guest_id
    scsi_type = data.vsphere_virtual_machine.winsrv_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.winsrv_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.winsrv_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.winsrv_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.winsrv_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.winsrv_template.id
    }

}
