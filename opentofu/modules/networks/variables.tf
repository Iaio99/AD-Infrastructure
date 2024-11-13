variable "project_name" {
  description = "Nome del progetto"
  type = string
}

variable "remote" {
  description = "Remote del progetto"
  type = string
}


variable "networks" {
  description = "List of networks"
  type = list(object({
    name = string
    ipv4 = string
  }))
}

variable "network_type" {
  type = string
  default = "ovn"
}

locals {
  network_type = var.project_name != "default" ? "ovn" : var.network_type
}