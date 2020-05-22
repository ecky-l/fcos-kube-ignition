resource "local_file" "fcos-ignition" {
  count = length(var.controllers)
  content = data.ct_config.controller-ignitions.*.rendered[count.index]
  filename = "output/controller-ignitions/controller-${count.index}.ign"
}

resource "local_file" "controller-netconfigs" {
  count = length(var.controllers)
  #content = templatefile("${path.module}/ignition/net-config.yaml", { netconfig = var.controllers.*.netconfig[count.index]})
  content = templatefile("${path.module}/ignition/baremin.yaml", {
    domain_name            = var.controllers.*.domain[count.index],
    node_ip                = var.controllers.*.ip[count.index],
    ssh_authorized_keys    = var.ssh_authorized_keys
  })
  filename = "output/netconfig-controller-${count.index}.yaml"
}

data "ct_config" "controller-ignitions" {
  count = length(var.controllers)
  #content  = data.template_file.controller-configs.*.rendered[count.index]
  content = templatefile("${path.module}/ignition/baremin.yaml", {
    domain_name            = var.controllers.*.domain[count.index],
    node_ip                = var.controllers.*.ip[count.index],
    ssh_authorized_keys    = var.ssh_authorized_keys
  })
  strict   = true
  pretty_print = true
  snippets = [
    templatefile("${path.module}/ignition/snippets/net-config.yaml", {
      net-config = var.controllers.*.netconfig[count.index]
    })
  ]
}

#data "template_file" "controller-configs" {
#  count = length(var.controllers)
#
#  template = file("${path.module}/ignition/baremin.yaml")
#  vars = {
#    domain_name            = var.controllers.*.domain[count.index]
#    node_ip                = var.controllers.*.ip[count.index]
#    ssh_authorized_key     = var.ssh_authorized_key
#  }
#}