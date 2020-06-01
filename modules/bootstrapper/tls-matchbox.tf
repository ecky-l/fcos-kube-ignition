
# ca cert and key
resource "tls_private_key" "matchbox-ca" {
  algorithm = "RSA"
  rsa_bits = "2048"
}

resource "tls_self_signed_cert" "matchbox-ca" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
  key_algorithm = tls_private_key.matchbox-ca.algorithm
  private_key_pem = tls_private_key.matchbox-ca.private_key_pem
  validity_period_hours = 8760
  early_renewal_hours = 24
  subject {
    common_name = "matchbox-ca"
    organization = "fcos-ignition"
  }
  is_ca_certificate = true
  set_subject_key_id = true
}

resource "local_file" "matchbox-ca-cert" {
  filename = "${var.certs_dir}/ca.crt"
  content = tls_self_signed_cert.matchbox-ca.cert_pem
}
resource "local_file" "matchbox-ca-key" {
  filename = "${var.certs_dir}/ca.key"
  content = tls_private_key.matchbox-ca.private_key_pem
}

# server cert and key
resource "tls_private_key" "matchbox-server" {
  algorithm = "RSA"
  rsa_bits = "2048"
}

resource "tls_cert_request" "matchbox-server" {
  key_algorithm = tls_private_key.matchbox-server.algorithm
  private_key_pem = tls_private_key.matchbox-server.private_key_pem
  subject {
    common_name = "matchbox-server"
    organization = "fcos-ignition:matchbox"
  }

  dns_names = [
    var.host_name,
    "localhost"
  ]
  ip_addresses = [
    "${var.vlan_config.ipv4}",
    "127.0.0.1"
  ]
}

resource "tls_locally_signed_cert" "matchbox-server" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  ca_cert_pem = tls_self_signed_cert.matchbox-ca.cert_pem
  ca_key_algorithm = tls_self_signed_cert.matchbox-ca.key_algorithm
  ca_private_key_pem = tls_private_key.matchbox-ca.private_key_pem
  cert_request_pem = tls_cert_request.matchbox-server.cert_request_pem
  validity_period_hours = 8760
}

resource "local_file" "matchbox-server-cert" {
  filename = "${var.certs_dir}/server.crt"
  content = tls_locally_signed_cert.matchbox-server.cert_pem
}

resource "local_file" "matchbox-server-key" {
  filename = "${var.certs_dir}/server.key"
  content = tls_private_key.matchbox-server.private_key_pem
}

# client cert and key
resource "tls_private_key" "matchbox-client" {
  algorithm = "RSA"
  rsa_bits = "2048"
}

resource "tls_cert_request" "matchbox-client" {
  key_algorithm = tls_private_key.matchbox-client.algorithm
  private_key_pem = tls_private_key.matchbox-client.private_key_pem
  subject {
    common_name = "matchbox-client"
    organization = "fcos-ignition:matchbox"
  }
}

resource "tls_locally_signed_cert" "matchbox-client" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
  ca_cert_pem = tls_self_signed_cert.matchbox-ca.cert_pem
  ca_key_algorithm = tls_self_signed_cert.matchbox-ca.key_algorithm
  ca_private_key_pem = tls_private_key.matchbox-ca.private_key_pem
  cert_request_pem = tls_cert_request.matchbox-client.cert_request_pem
  validity_period_hours = 8760
}

resource "local_file" "matchbox-client-cert" {
  filename = "${var.certs_dir}/client.crt"
  content = tls_locally_signed_cert.matchbox-client.cert_pem
}

resource "local_file" "matchbox-client-key" {
  filename = "${var.certs_dir}/client.key"
  content = tls_private_key.matchbox-client.private_key_pem
}