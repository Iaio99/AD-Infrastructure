resource "incus_project" "project" {
  name = var.project_name
  
  config = {
    "features.profiles" = true
  }
}

resource "incus_storage_pool" "pool" {
  name   = "adpool"
  driver = "dir"
  project = var.project_name
}

resource "incus_profile" "profile" {
  name = "ad"
  
  project = var.project_name

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "adpool"
      path = "/"
    }
  }
}
