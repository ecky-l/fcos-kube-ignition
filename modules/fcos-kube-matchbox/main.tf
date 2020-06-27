locals {
  cached_kernel = "/assets/fedora-coreos/fedora-coreos-${var.os_version}-live-kernel-x86_64"
  cached_initrd = "/assets/fedora-coreos/fedora-coreos-${var.os_version}-live-initramfs.x86_64.img"
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
    # for the next line to work, the .raw.xz must be downloaded to the appropriate place.
    # !!! AND the .raw.xz.sig file must be downloaded from the same location and placed next to the .raw.xz file !!!
    # If the .sig file is not present, there will be a hang-screen during PXE boot and no message why.
    "coreos.inst.image_url=${var.matchbox_http_endpoint}/assets/fedora-coreos/fedora-coreos-${var.os_version}-metal.x86_64.raw.xz",
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