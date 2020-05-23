module "virtualbox-k8s-matchbox" {
  source = "../../../modules/fcos-kube-matchbox"

  cluster_name = "vitualbox-local"
  os_version = "31.20200420.3.0"
  matchbox_http_endpoint = "http://10.10.0.1:8080"

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]

  controllers = [{
    name   = "k1.home.el"
    mac    = "08:00:27:16:D1:FC"
    domain = "k1.home.el"
    advertise_ip = "192.168.56.20"
    netconfig = [{
      interface = "eth2"
      method = "manual"
      ip = "192.168.56.20"
      dns = "192.168.2.10"
    }]
  }]
  #workers = []
}