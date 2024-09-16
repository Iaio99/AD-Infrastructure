variable "networks" {
  description = "List of networks"
  type        = list(object({
    name = string
    ipv4 = string
  }))
}
