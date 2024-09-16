module "profile" {
  source = "./modules/profile"
  depends_on = [module.networks]
}

module "networks" {
  source = "./modules/networks"
  
  networks = [
    {
      name = "vulnbox0"
      cidr = "10.60.255.254/16"
    },
    {
      name = "team0"
      cidr = "10.80.255.254/16"
    },
    {
      name = "gameserver0"
      cidr = "10.10.0.2/30"
    }
  ]

}
