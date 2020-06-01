
//resource "local_file" "test" {
//  filename = "debug/out.yaml"
//  content = templatefile("${path.module}/templates/snippets/net-config.yaml", {
//    net_config = var.net_config
//    vlan_config = var.vlan_config
//    public_interface = var.public_interface
//  })
//}

data "ct_config" "bootstrapper-ignition" {
  strict = true
  content = templatefile("${path.module}/templates/bootstrapper.yaml", {
    host_name = var.host_name
    ssh_authorized_keys = var.ssh_authorized_keys
  })
  snippets = [
    templatefile("${path.module}/templates/snippets/net-config.yaml", {
      net_config = var.net_config
      vlan_config = var.vlan_config
      public_interface = var.public_interface
    }),
    templatefile("${path.module}/templates/snippets/dhcpd.yaml", {
      dhcpd = var.dhcpd_config
      vlan_ip = var.vlan_config.ipv4
    }),
    templatefile("${path.module}/templates/snippets/tftpd.yaml", {
      vlan_ip = var.vlan_config.ipv4
    }),
    templatefile("${path.module}/templates/snippets/matchbox.yaml", {
      ca_cert = tls_self_signed_cert.matchbox-ca.cert_pem,
      server_cert = tls_locally_signed_cert.matchbox-server.cert_pem,
      server_key = tls_private_key.matchbox-server.private_key_pem
      vlan_ip = var.vlan_config.ipv4
      download_fcos_versions = var.download_fcos_versions
    }),
    templatefile("${path.module}/templates/snippets/pdns.yaml", {
      vlan_config = var.vlan_config
      public_dns = var.public_dns
    })
  ]
}