variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core'"
}

variable "dns" {
  type = string
  description = "DNS used for dhcpd and net config"
  default = "8.8.8.8"
}

variable "dhcpd_config" {
  type = object({
    interface = string
    domain_name = string
    ip = string
    net = string
    netmask = string
    range_lower = string
    range_upper = string
    broadcast = string
  })
  description = "DHCP parameters"
  default = {
    interface = "eth2"
    domain_name = "example.com"
    ip = "10.10.0.1"
    net = "10.10.0.0"
    netmask = "255.255.0.0"
    range_lower = "10.10.1.0"
    range_upper = "10.10.255.254"
    broadcast = "10.10.255.255"
  }
}

variable "net_config" {
  type = list(object({
    interface = string
    method = string
    ipnet = string
    dns = string
  }))
  description = "Network configuration for the bootstrap host"
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