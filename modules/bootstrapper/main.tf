
resource "local_file" "test" {
  filename = "out/out.yaml"
  content = templatefile("${path.module}/templates/bootstrapper.yaml", {
    ssh_authorized_keys    = var.ssh_authorized_keys
  })
}

data "ct_config" "bootstrapper-ignition" {
  strict   = true
  pretty_print = true
  content = templatefile("${path.module}/templates/bootstrapper.yaml", {
    ssh_authorized_keys    = var.ssh_authorized_keys
  })
  snippets = [
    templatefile("${path.module}/templates/snippets/net-config.yaml", {
      net_config = var.net_config
    }),
    templatefile("${path.module}/templates/snippets/dhcpd.yaml", {
      domain_name = var.domain_name
      dhcpd_dns = var.dhcpd_dns
      dhcpd_interface = var.dhcpd_interface
    }),
    file("${path.module}/templates/snippets/tftpd.yaml")
  ]
}