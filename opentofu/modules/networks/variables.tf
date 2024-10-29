variable "project_name" {
  description = "Nome del progetto ricevuto dal modulo root"
  type        = string
}

variable "networks" {
  description = "List of networks"
  type        = list(object({
    name = string
    ipv4 = string
  }))
}

variable "network_type" {
  type = string
  default = "bridge"

}

locals {
  network_type = var.project_name != "default" ? "ovn" : var.network_type
}