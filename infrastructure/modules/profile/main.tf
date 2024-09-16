resource "incus_storage_pool" "pool" {
  name   = "adpool"
  driver = "dir"
}

resource "incus_profile" "profile" {
  name = "ad"

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "adpool"
      path = "/"
    }
  }
}
