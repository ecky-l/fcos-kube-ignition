
module "virtualbox-bootstrapper" {
  source = "../../../modules/bootstrapper"
  host_name = "befruchter.home.el"
  public_dns = "192.168.2.10"

  net_config = {
    "eth1" = {
      "ipv4" = {
        "method" = "manual"
        "address1" = "10.10.0.1/16"
        "dns" = "10.10.0.1"
        "dns-search" = "local.vlan;"
      }
      "ipv6" = {
        "method" = "manual"
        "addr-gen-mode"= "stable-privacy"
        "address1" = "fd75:bf9e:ed67:7438::1/64"
        "dns" = "fd75:bf9e:ed67:7438::1;"
        "dns-search" = "local.vlan;"
      }
    }
    "eth2" = {
      "ipv4" = {
        "method" = "manual"
        "address1" = "192.168.56.19/24"
      }
    }
  }

  ssh_authorized_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]
}
resource "local_file" "bootstrapper-ignition" {
  content = module.virtualbox-bootstrapper.bootstrapper-ignition
  filename = "output/bootstrapper.ign"
}