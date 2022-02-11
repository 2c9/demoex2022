terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
    vsphere = {
        source = "hashicorp/vsphere"
    }
  }
}

variable "vsphere_server" {
  type = string
  default = "vcsacluster.ouiit.local"
}

variable "vsphere_user" {
  type = string
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type = string
}

variable "nsxt_server" {
  type = string
  default = "172.30.77.57"
}

variable "nsxt_user" {
  type = string
  default = "dmitry@ouiit.local"
}

variable "nsxt_password" {
  type = string
}

provider "nsxt" {
  host                  = var.nsxt_server
  username              = var.nsxt_user
  password              = var.nsxt_password
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}