
data "ct_config" "controller-ignitions" {
  count = length(var.controllers)
  content = templatefile("${path.module}/templates/kube.yaml", {
    domain_name            = var.controllers.*.domain[count.index],
    advertise_ip                = var.controllers.*.advertise_ip[count.index],
    ssh_authorized_keys    = var.ssh_authorized_keys
  })
  strict   = true
  pretty_print = false

  snippets = [
    templatefile("${path.module}/templates/snippets/net-config.yaml", {
      net-config = var.controllers.*.netconfig[count.index]
    }),
    templatefile("${path.module}/templates/snippets/install-kubernetes.yaml", {
      kubernetes_version  = var.kubernetes_version
      crictl_version      = var.crictl_version
      domain_name         = var.controllers.*.domain[count.index]
      advertise_ip        = var.controllers.*.advertise_ip[count.index]
      setup_command       = "kubeadm init --config=/etc/kubernetes/kubeadm-custom-config.yaml"
    }),
    templatefile("${path.module}/templates/snippets/kubeadm-custom-config.yaml", {
      kubernetes_version   = var.kubernetes_version
      domain_name          = var.controllers.*.domain[count.index]
      advertise_ip         = var.controllers.*.advertise_ip[count.index]
      apiserver_extra_sans = var.apiserver_extra_sans
      pod_subnet           = var.pod_subnet
      service_subnet       = var.service_subnet
    })
  ]
}


