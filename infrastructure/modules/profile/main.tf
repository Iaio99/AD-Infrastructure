resource "incus_storage_pool" "pool" {
  name   = "adpool"
  driver = "dir"
}

resource "incus_profile" "profile" {
  name = "ad"

  device {
    type = "nic"
    name = "game0"
    
    properties = {
      network = "vulnbox0"
    }
  } 

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "adpool"
      path = "/"
    }
  }
}
