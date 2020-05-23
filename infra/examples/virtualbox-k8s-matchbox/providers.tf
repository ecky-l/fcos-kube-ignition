provider "matchbox" {
  version = "0.3.0"
  endpoint    = "befruchter.home.el:8081"
  client_cert = file("tls/client.crt")
  client_key  = file("tls/client.key")
  ca          = file("tls/ca.crt")
}

provider "ct" {
  version = "0.5.0"
}
