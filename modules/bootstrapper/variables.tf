variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core'"
}

variable "public_dns" {
  type = string
  description = "The public DNS servers, separated by ; Used for pdns-recursor to forward all zones other than the .vlan"
  default = "8.8.8.8"
}

variable "public_interface" {
  type = string
  description = "The public interface, e.g. eth0. Used for NAT configuration"
  default = "eth0"
}

variable "vlan_config" {
  type = object({
    interface = string
    ipv4 = string
    netv4 = string
  })
  description = "The vlan interface and ip for this host"
  default = {
    interface = "eth1"
    ipv4 = "10.10.0.1"
    netv4 = "10.10.0.0/16"
  }
}

variable "dhcpd_config" {
  type = object({
    interface = string
    domain_name = string
    dns = string
    net = string
    netmask = string
    range_lower = string
    range_upper = string
    broadcast = string
  })
  description = "DHCP parameters"
  default = {
    interface = "eth1"
    domain_name = "local.vlan"
    dns = "10.10.0.1"
    net = "10.10.0.0"
    netmask = "255.255.0.0"
    range_lower = "10.10.1.0"
    range_upper = "10.10.255.254"
    broadcast = "10.10.255.255"
  }
}

variable "net_config" {
  type = map(map(map(string)))
  description = <<EOD
NetworkManager profile settings. Toplevel keys correspond to a profile (NIC), next level keys to INI keys within
the profile. See https://developer.gnome.org/NetworkManager/stable/nm-settings.html for a complete reference
EOD
  default = {
    "eth0" = {
      "ipv4" = {
        "method" = "auto"
      },
      "ipv6" = {
        "method" = "auto"
      }
    }
  }
}

variable "host_name" {
  type = string
  description = "Hostname of the bootstrapper"
}

variable "certs_dir" {
  type = string
  description = "Directory where to save the generated certs"
  default = "output/tls/matchbox"
}

variable "download_fcos_versions" {
  type = list(string)
  description = "A list of Fedora CoreOS versions for which the PXE files should be downloaded to matchbox assets dir"
  default = [
    "32.20200601.3.0"
  ]
}