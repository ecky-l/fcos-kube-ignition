module "virtualbox-example" {
  source = "./modules/fcos-kube-ignition"
  os_version = "31.20200420.3.0"
  matchbox_http_endpoint = "http://192.168.56.1:8080"

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]

  controllers = [{
    name   = "k1.home.el"
    mac    = "08:00:27:16:D1:FC"
    domain = "k1.home.el"
    advertise_ip = "192.168.56.20"
    netconfig = [{
      interface = "eth1"
      method = "manual"
      ip = "192.168.56.20"
      dns = "192.168.2.10"
    }]
  }]
  #workers = []

}

resource "local_file" "fcos-controller-ignitions" {
  count = length(module.virtualbox-example.controller-ignitions)
  content = module.virtualbox-example.controller-ignitions[count.index]
  filename = "output/controller-${count.index}.ign"
}

module "virtualbox-bootstrapper" {
  source = "./modules/bootstrapper"
  dhcpd_dns = "192.168.2.10"
  domain_name = "home.el"
  net_config = [{
    interface = "eth1"
    method = "manual"
    ipnet = "192.168.56.18/24"
    dns = "192.168.2.10"
  },{
    interface = "eth2"
    method = "manual"
    ipnet = "10.10.0.1/16"
    dns = "192.168.2.10"
  }

  ]
  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]
}
resource "local_file" "bootstrapper-ignition" {
  content = module.virtualbox-bootstrapper.bootstrapper-ignition
  filename = "output/bootstrapper.ign"
}