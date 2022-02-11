data "vsphere_network" "network_isp_cli" {
    depends_on = [ null_resource.wait ]
    name       = format("${var.prefix}ISP_CLI_${var.index}")
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_isp_rtrl" {
    depends_on = [ null_resource.wait ]
    name       = format("${var.prefix}ISP_RTR-L_${var.index}")
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_isp_rtrr" {
    depends_on = [ null_resource.wait ]
    name       = format("${var.prefix}ISP_RTR-R_${var.index}")
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_rtrl" {
    depends_on = [ null_resource.wait ]
    name       = format("${var.prefix}RTR-L_${var.index}")
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_rtrr" {
    depends_on = [ null_resource.wait ]
    name       = format("${var.prefix}RTR-R_${var.index}")
    datacenter_id = data.vsphere_datacenter.dc.id
}