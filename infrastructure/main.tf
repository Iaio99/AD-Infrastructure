module "profile" {
  source = "./modules/profile"
  depends_on = [module.networks]
}

module "networks" {
  source = "./modules/networks"
  
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

module "containers" {
  source = "./modules/containers"
  depends_on = [module.networks, module.profile]
  teams = concat(["nop"], jsondecode(file(var.teams_file)))
}