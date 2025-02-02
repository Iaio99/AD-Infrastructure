/*
module "profile" {
  source = "./modules/profile"
  depends_on = [module.networks]

  project_name = var.project_name
  remote = var.remote
}
*/

provider "incus" {
  remote {
    name = var.remote
    scheme = "https"
    address = "192.168.122.2"
    default = true
  }
}

module "networks" {
  source = "./modules/networks"

  project_name = var.project_name

  networks = var.networks
}

module "instances" {  
  source = "./modules/instances"
//  depends_on = [module.networks, module.profile]
  depends_on = [module.networks]

  project_name = var.project_name
  instance_type = var.instances_type
  teams = concat(["nop"], var.teams)
}
