module "virtualbox-k8s-matchbox" {
  source = "../../../modules/fcos-kube-matchbox"

  cluster_name = "vitualbox-local"
  os_version = "31.20200505.3.0"
  matchbox_http_endpoint = "http://10.10.0.1:8080"

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]

  apiserver_extra_sans = [
    "192.168.56.20",
    "k1.home.el"
  ]

  controllers = [{
    name   = "k1.local.vlan"
    mac    = "08:00:27:16:D1:FC"
    #mac    = "08:00:27:FF:96:A3"
    domain = "k1.local.vlan"
    advertise_ip = "10.10.0.10"
    netconfig = [{
      interface = "eth0"
      auto = null
      manual = {
        ipnet = "10.10.0.10/16"
        dns = "10.10.0.1"
        gateway = null
      }
    }, {
      interface = "eth1"
      auto = {
        never_default = false
        ignore_auto_dns = false
      }
      manual = null
    }, {
      interface = "eth2"
      auto = null
      manual = {
        ipnet = "192.168.56.20/24"
        dns = null
        gateway = null
      }
    }]
  }]
  #workers = []
}