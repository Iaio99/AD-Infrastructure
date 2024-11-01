resource "incus_network" "network" {
  for_each = { for network in var.networks : network.name => network }
  
  name = each.value.name
  
  config = {
    "ipv4.address" = each.value.ipv4
    "ipv4.nat" = "true"
    "ipv4.dhcp" = "true"
  }

  type = ovn
}