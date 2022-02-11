data "nsxt_policy_transport_zone" "overlay_tz" {
    display_name = "NSX-OV"
}

data "nsxt_policy_ip_discovery_profile" "ipd_profile" {
  display_name = "allow-dhcp-ipdiscover"
}

data "nsxt_policy_segment_security_profile" "ssec_profile" {
  display_name = "allow-dhcp-security"
}

resource "nsxt_policy_segment" "tf_isp_cli" {
    display_name        = format("${var.prefix}ISP_CLI_${var.index}")
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_isp_rtrl" {
    display_name        = format("${var.prefix}ISP_RTR-L_${var.index}")
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_isp_rtrr" {
    display_name        = format("${var.prefix}ISP_RTR-R_${var.index}")
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_rtrl" {
    display_name        = format("${var.prefix}RTR-L_${var.index}")
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_rtrr" {
    display_name        = format("${var.prefix}RTR-R_${var.index}")
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

########################################################################
# Wait for NSX-T to provision networks in order to get them in vCenter #
########################################################################

resource "null_resource" "wait" {
  triggers = {
      rtrr     = nsxt_policy_segment.tf_rtrr.display_name,
      rtrl     = nsxt_policy_segment.tf_rtrl.display_name,
      isp_cli  = nsxt_policy_segment.tf_isp_cli.display_name,
      isp_rtrl = nsxt_policy_segment.tf_isp_rtrl.display_name,
      isp_rtrr = nsxt_policy_segment.tf_isp_rtrr.display_name
  }
  provisioner "local-exec" {
    environment = {
        networks = format("${nsxt_policy_segment.tf_isp_cli.display_name},${nsxt_policy_segment.tf_isp_rtrl.display_name},${nsxt_policy_segment.tf_isp_rtrr.display_name},${nsxt_policy_segment.tf_rtrl.display_name},${nsxt_policy_segment.tf_rtrr.display_name}")
    }
    command = "pwsh ./helpers/getnets.ps1"
    when = create
  }
}