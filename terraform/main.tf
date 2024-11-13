locals {
  config = jsondecode(file(var.config_file))
  project_name = local.config["incus_cluster"]["project_name"]
  remote = local.config["incus_cluster"]["remote"]
}

/*
module "profile" {
  source = "./modules/profile"
  depends_on = [module.networks]

  project_name = local.project_name
  remote = local.remote
}
*/
module "networks" {
  source = "./modules/networks"

  project_name = local.project_name
  remote = local.remote

  networks = [
    {
      name = "vulnboxes-network"
      ipv4 = "10.60.255.254/16"
    },
    {
      name = "vpn-servers-network"
      ipv4 = "10.80.255.254/16"
    },
    {
      name = "gameserver-network"
      ipv4 = "10.10.0.2/30"
    }
  ]
}

module "instances" {  
  source = "./modules/instances"
//  depends_on = [module.networks, module.profile]
  depends_on = [module.networks]

  project_name = local.project_name
  remote = local.remote
  instance_type = local.config["incus_cluster"]["instances_type"]
  teams = concat(["nop"], local.config["ad-platform"]["teams"])
}
