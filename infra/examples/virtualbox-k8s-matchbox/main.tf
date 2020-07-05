module "virtualbox-k8s-matchbox" {
  source = "../../../modules/fcos-kube-matchbox"

  cluster_name = "vitualbox-local"
  matchbox_http_endpoint = "http://10.10.0.1:8080"

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]

  apiserver_extra_sans = [
    "192.168.56.20",
    "k1.home.el"
  ]

  k8s_domain_name = "k1.local.vlan"

  controllers = [{
    name   = "k1.local.vlan"
    mac    = "08:00:27:16:D1:FC"
    #mac    = "08:00:27:FF:96:A3"
    domain = "k1.local.vlan"
    advertise_ip = "10.10.0.10"
    root_partition_size_gib = 24
    net_config = {
      "eth0" = {
        "ipv4" = {
          "method" = "manual"
          "address1" = "10.10.0.10/16,10.10.0.1"
          "dns" = "10.10.0.1;"
          "dns-search" = "local.vlan;"
        }
      }
      "eth1" = {
        "ipv4" = {
          "method" = "manual"
          "address1" = "192.168.56.20/24"
        }
      }
    }
  }]
  #workers = []
}
