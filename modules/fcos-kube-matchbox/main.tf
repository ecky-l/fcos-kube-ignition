locals {
  cached_kernel = "/assets/fcos/${var.os_version}/fedora-coreos-${var.os_version}-live-kernel-x86_64"
  cached_initrd = "/assets/fcos/${var.os_version}/fedora-coreos-${var.os_version}-live-initramfs.x86_64.img"
  boot_args = [
    "ip=dhcp",
    "rd.neednet=1",
    "initrd=fedora-coreos-${var.os_version}-live-initramfs.x86_64.img",
    "console=tty0",
    "console=ttyS0",
    "ignition.firstboot",
    "ignition.platform.id=metal",
    "coreos.inst.install_dev=${var.install_disk}",
    "coreos.inst.stream=${var.os_stream}",
    #"coreos.inst.image_url=${var.matchbox_http_endpoint}/assets/fcos/${var.os_version}/fedora-coreos-${var.os_version}-metal.x86_64.raw.xz",
    "coreos.inst.ignition_url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
  ]

  kernel = local.cached_kernel
  initrd = local.cached_initrd
  args   = local.boot_args
}

resource "matchbox_profile" "controllers" {
  count = length(var.controllers)
  name  = format("%s-controller-%s", var.cluster_name, var.controllers.*.name[count.index])

  kernel = local.kernel
  initrd = [
    local.initrd
  ]
  args = concat(local.args, var.kernel_args)

  raw_ignition = module.fcos-kube-ignition.controller-ignitions[count.index]
}

resource "matchbox_group" "controller" {
  count   = length(var.controllers)
  name    = format("%s-%s", var.cluster_name, var.controllers.*.name[count.index])
  profile = matchbox_profile.controllers.*.name[count.index]

  selector = {
    mac = var.controllers.*.mac[count.index]
  }
}