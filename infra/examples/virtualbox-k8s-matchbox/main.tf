module "virtualbox-k8s-matchbox" {
  source = "../../../modules/fcos-kube-matchbox"

  cluster_name = "vitualbox-local"
  os_version = "31.20200505.3.0"
  matchbox_http_endpoint = "http://10.10.0.1:8080"

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]

  controllers = [{
    name   = "k1.local.vlan"
    mac    = "08:00:27:16:D1:FC"
    #mac    = "08:00:27:FF:96:A3"
    domain = "k1.local.vlan"
    advertise_ip = null #"192.168.56.20"
    netconfig = [{
      interface = "eth0"
      method = "manual"
      gateway = null
      ipnet = "10.10.0.10/16"
      dns = "10.10.0.1"
    }, {
      interface = "eth1"
      method = "auto"
      gateway = ""
      ipnet = ""
      dns = ""
    }, {
      interface = "eth2"
      method = "manual"
      gateway = null #"192.168.56.1"
      ipnet = "192.168.56.20/24"
      dns = "192.168.2.10"
    }]
  }]
  #workers = []
}