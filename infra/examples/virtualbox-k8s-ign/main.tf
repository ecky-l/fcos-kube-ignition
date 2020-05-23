module "virtualbox-example" {
  source = "../../../modules/fcos-kube-ignition"

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