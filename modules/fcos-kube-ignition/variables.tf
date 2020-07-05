
variable "kubernetes_version" {
  type = string
  description = "The kubernetes version"
  default = "v1.18.4"
}

variable "cni_version" {
  type = string
  description = "The cni plugins version"
  default = "v0.8.6"
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

variable "apiserver_extra_sans" {
  type = list(string)
  description = "List of extra SANs to add for certificate generation. Can be hostnames and ips"
  default = null
}

variable "k8s_domain_name" {
  type        = string
  description = "Controller DNS name which resolves to a controller instance."
}

variable "controllers" {
  type = list(object({
    name = string
    mac = string
    domain = string
    advertise_ip = string
    net_config = map(map(map(string)))
    root_partition_size_gib = number
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
    net_config = map(map(map(string)))
    root_partition_size_gib = number
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