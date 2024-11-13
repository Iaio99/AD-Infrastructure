resource "incus_project" "project" {
  name = var.project_name
  remote = var.remote
  
  config = {
    "features.profiles" = true
  }
}

resource "incus_storage_pool" "pool" {
  name   = "adpool"
  driver = "dir"
  project = var.project_name
  remote = var.remote
}

resource "incus_profile" "profile" {
  name = "ad"
  
  project = var.project_name
  remote = var.remote

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "adpool"
      path = "/"
    }
  }
}
