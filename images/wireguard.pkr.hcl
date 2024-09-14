source "incus" "wireguard" {
  image = "images:alpine/3.20"
  output_image = "wireguard"
  reuse = true
  publish_properties =  {
    description = "Trivial repackage with Packer"
  }
}

build {
  sources = ["source.incus.wireguard"]

  provisioner "shell" {
    inline  = [
	"apk add iptables wireguard-tools-wg-quick"
    ]
  }
}
