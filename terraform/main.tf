/*
module "profile" {
  source = "./modules/profile"
  depends_on = [module.networks]

  project_name = project_name
  remote = remote
}
*/
module "networks" {
  source = "./modules/networks"

  project_name = project_name
  remote = remote

  networks = networks
}

module "instances" {  
  source = "./modules/instances"
//  depends_on = [module.networks, module.profile]
  depends_on = [module.networks]

  project_name = project_name
  remote = remote
  instance_type = instances_type
  teams = concat(["nop"], teams)
}
