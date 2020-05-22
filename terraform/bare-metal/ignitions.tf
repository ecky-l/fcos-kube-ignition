resource "local_file" "fcos-ignition" {
  count = length(var.controllers)
  content = data.ct_config.controller-ignitions.*.rendered[count.index]
  filename = "output/controller-ignitions/controller-${count.index}.ign"
}

data "ct_config" "controller-ignitions" {
  count = length(var.controllers)
  #content  = data.template_file.controller-configs.*.rendered[count.index]
  content = templatefile("${path.module}/ignition/kube.yaml", {
    domain_name            = var.controllers.*.domain[count.index],
    advertise_ip                = var.controllers.*.advertise_ip[count.index],
    ssh_authorized_keys    = var.ssh_authorized_keys
  })
  strict   = true
  pretty_print = true

  snippets = [
    templatefile("${path.module}/ignition/snippets/net-config.yaml", {
      net-config = var.controllers.*.netconfig[count.index]
    }),
    templatefile("${path.module}/ignition/snippets/install-kubernetes.yaml", {
      kubernetes_version  = var.kubernetes_version
      crictl_version      = var.crictl_version
      domain_name         = var.controllers.*.domain[count.index]
      advertise_ip        = var.controllers.*.advertise_ip[count.index]
      setup_command       = "kubeadm init --config=/etc/kubernetes/kubeadm-custom-config.yaml"
    }),
    templatefile("${path.module}/ignition/snippets/kubeadm-custom-config.yaml", {
      kubernetes_version  = var.kubernetes_version
      domain_name         = var.controllers.*.domain[count.index]
      advertise_ip        = var.controllers.*.advertise_ip[count.index]
      pod_subnet          = var.pod_subnet
      service_subnet      = var.service_subnet
    })
  ]
}


