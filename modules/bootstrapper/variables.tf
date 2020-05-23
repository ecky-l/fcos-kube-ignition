variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core'"
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

variable "domain_name" {
  type = string
  description = "Domain name of the bootstrapper"
}

variable "dhcpd_dns" {
  type = string
  description = "DNS for dhcpd configuration"
}

variable "dhcpd_interface" {
  type = string
  description = "The interface for dhcpd"
  default = "eth2"
}