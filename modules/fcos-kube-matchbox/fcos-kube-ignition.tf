module "fcos-kube-ignition" {
  source = "../fcos-kube-ignition"

  ssh_authorized_keys = var.ssh_authorized_keys

  controllers = var.controllers
  workers = var.workers
  kubernetes_version = var.kubernetes_version
  crictl_version = var.crictl_version
  pod_subnet = var.pod_subnet
  service_subnet = var.service_subnet
}