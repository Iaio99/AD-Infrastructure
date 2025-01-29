/*
module "profile" {
  source = "./modules/profile"
  depends_on = [module.networks]

  project_name = var.project_name
  remote = var.remote
}
*/
module "networks" {
  source = "./modules/networks"

  project_name = var.project_name
  remote = var.remote

  networks = var.networks
}

module "instances" {  
  source = "./modules/instances"
//  depends_on = [module.networks, module.profile]
  depends_on = [module.networks]

  project_name = var.project_name
  remote = var.remote
  instance_type = var.instances_type
  teams = concat(["nop"], teams)
}
