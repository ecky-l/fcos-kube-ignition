
data "ct_config" "bootstrapper-ignition" {
  strict = true
  pretty_print = true
  content = templatefile("${path.module}/templates/bootstrapper.yaml", {
    host_name = var.host_name
    ssh_authorized_keys = var.ssh_authorized_keys
  })
  snippets = [
    templatefile("${path.module}/templates/snippets/net-config.yaml", {
      net_config = var.net_config
    }),
    templatefile("${path.module}/templates/snippets/dhcpd.yaml", {
      host_name = var.host_name
      domain_name = var.domain_name
      dhcpd_dns = var.dhcpd_dns
      dhcpd_interface = var.dhcpd_interface
    }),
    file("${path.module}/templates/snippets/tftpd.yaml"),
    templatefile("${path.module}/templates/snippets/matchbox.yaml", {
      ca_cert = tls_self_signed_cert.matchbox-ca.cert_pem,
      server_cert = tls_locally_signed_cert.matchbox-server.cert_pem,
      server_key = tls_private_key.matchbox-server.private_key_pem
    })
  ]
}