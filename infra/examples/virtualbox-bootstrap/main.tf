
module "virtualbox-bootstrapper" {
  source = "../../../modules/bootstrapper"
  dhcpd_dns = "192.168.2.10"
  host_name = "befruchter.home.el"
  domain_name = "home.el"
  net_config = [{
    interface = "eth1"
    method = "manual"
    ipnet = "192.168.56.19/24"
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