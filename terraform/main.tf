locals {
  config = jsondecode(file(var.config_file))
}

module "profile" {
  source = "./modules/profile"
  project_name = var.project_name
  depends_on = [module.networks]
}

module "networks" {
  source = "./modules/networks"
  project_name = var.project_name

  networks = [
    {
      name = "vulnbox0"
      ipv4 = "10.60.255.254/16"
    },
    {
      name = "team0"
      ipv4 = "10.80.255.254/16"
    },
    {
      name = "gameserver0"
      ipv4 = "10.10.0.2/30"
    }
  ]
}

module "instances" {  
  source = "./modules/instances"
  project_name = var.project_name
  instance_type = local.config["instances_type"]
  depends_on = [module.networks, module.profile]
  teams = concat(["nop"], local.config["teams"])
}
