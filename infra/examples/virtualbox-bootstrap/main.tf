
module "virtualbox-bootstrapper" {
  source = "../../../modules/bootstrapper"
  host_name = "befruchter.home.el"
  public_dns = "192.168.2.10"
  net_config = [{
    interface = "eth1"
    method = "manual"
    ipnet = "10.10.0.1/16"
    gateway = null
    dns = "10.10.0.1"
  },{
    interface = "eth2"
    method = "manual"
    ipnet = "192.168.56.19/24"
    gateway = null
    dns = null
  }]

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]
}
resource "local_file" "bootstrapper-ignition" {
  content = module.virtualbox-bootstrapper.bootstrapper-ignition
  filename = "output/bootstrapper.ign"
}