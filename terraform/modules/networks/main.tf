resource "incus_network" "network" {
  for_each = { for network in var.networks : network.network_name => network }
  
  name = each.value.network_name
  remote = var.remote
  project = var.project_name
  type = var.network_type

  config = {
    "ipv4.address" = each.value.ipv4
    "ipv4.nat" = "true"
    "ipv4.dhcp" = "true"
    "network" = "incusbr0"
  }
}