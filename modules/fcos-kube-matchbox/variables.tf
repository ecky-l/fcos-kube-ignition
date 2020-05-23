variable "cluster_name" {
  type        = string
  description = "Unique cluster name"
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
variable "kubernetes_version" {
  type = string
  description = "The kubernetes version"
  default = "v1.18.3"
}

variable "crictl_version" {
  type = string
  description = "The crictl version"
  default = "v1.18.0"
}

variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core'"
}

variable "controllers" {
  type = list(object({
    name   = string
    mac    = string
    domain = string
    advertise_ip = string
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
    netconfig = list(object({
      interface = string
      method = string
      ip = string
      dns = string
    }))
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

variable "pod_subnet" {
  type = string
  description = "Pod Subnet"
  default = "10.244.0.0/16"
}

variable "service_subnet" {
  type = string
  description = "Service subnet"
  default = "10.96.0.0/12"
}

variable "install_disk" {
  type        = string
  description = "Disk device to install Fedora CoreOS (e.g. /dev/sda)"
  default     = "/dev/sda"
}

variable "kernel_args" {
  type        = list(string)
  description = "Additional kernel arguments to provide at PXE boot."
  default     = []
}