data "nsxt_policy_transport_zone" "overlay_tz" {
    display_name = "NSX-OV"
}

data "nsxt_policy_ip_discovery_profile" "ipd_profile" {
  display_name = "allow-dhcp-ipdiscover"
}

data "nsxt_policy_segment_security_profile" "ssec_profile" {
  display_name = "allow-dhcp-security"
}