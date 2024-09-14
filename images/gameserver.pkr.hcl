source "incus" "gameserver" {
  image = "images:debian/12"
  output_image = "gameserver"
  reuse = true
  publish_properties =  {
    description = "Image for the gameserver"
  }
}

build {
  sources = ["source.incus.gameserver"]

  provisioner "shell" {
    inline  = [
        "apt install -y python3 nginx"
    ]
  }
}
