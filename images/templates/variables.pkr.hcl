locals {
  config = jsondecode(file("${path.root}/../../configs.json"))
}