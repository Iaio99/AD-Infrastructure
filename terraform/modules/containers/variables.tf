variable "teams" {
  description = "List of teams that will partecipate"
  type = list(string)
}

variable "instance_type" {
  type = string
  default = "container"

  validation {
    condition = contains(["container", "virtual-machine"], var.instance_type)
  }
}