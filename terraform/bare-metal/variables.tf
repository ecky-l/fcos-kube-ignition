variable "fcos_pxe_mirror" {
  type        = string
  description = "Download mirror for Fedora CoreOS kernel and initramfs image, used during PXE boot."
  default     = "https://builds.coreos.fedoraproject.org"
}

variable "matchbox_http_endpoint" {
  type        = string
  description = "Matchbox HTTP read-only endpoint (e.g. http://matchbox.example.com:8080)"
}

variable "os_stream" {
  type        = string
  description = "Fedora CoreOS release stream (e.g. testing, stable)"
  default     = "stable"
}

variable "os_version" {
  type        = string
  description = "Fedora CoreOS version to PXE and install (e.g. 31.20200310.3.0)"
}

variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core'"
}

variable "node_dns" {
  type = string
  description = "Node DNS"
  default = "8.8.8.8"
}

variable "controllers" {
  type = list(object({
    name   = string
    mac    = string
    domain = string
    ip     = string
    netconfig = list(object({
      interface = string
      method = string
      ip = string
      dns = string
    }))
  }))
  description = <<EOD
List of controller machine details (unique name, identifying MAC address, FQDN)
[{ name = "node1", mac = "52:54:00:a1:9c:ae", domain = "node1.example.com", ip = "10.10.10.10"}]
EOD
}

variable "workers" {
  type = list(object({
    name   = string
    mac    = string
    domain = string
    ip     = string
  }))
  description = <<EOD
List of worker machine details (unique name, identifying MAC address, FQDN)
[
  { name = "node2", mac = "52:54:00:b2:2f:86", domain = "node2.example.com", ip = "10.10.10.11"},
  { name = "node3", mac = "52:54:00:c3:61:77", domain = "node3.example.com", ip = "10.10.10.12"}
]
EOD
  default = []
}