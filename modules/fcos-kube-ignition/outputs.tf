output "controller-ignitions" {
  value = data.ct_config.controller-ignitions.*.rendered
}