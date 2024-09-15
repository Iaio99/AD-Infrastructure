source "incus" "vulnbox" {
  image = "images:debian/12"
  output_image = "vulnbox"
  reuse = true
  profile = "build"
  publish_properties =  {
    description = "Image for the servers where the vulnerable services will be hosted"
  }
}

build {
  sources = ["source.incus.vulnbox"]

  provisioner "shell" {
    inline  = [
        "apt install -y sudo python-is-python3 python3 cron vim tcpdump tmux bash-completion openssh-server",
        "sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config",
	"sed -i 's/^Name=eth0/Name=game/' /etc/systemd/network/eth0.network",
	"rename.ul eth0 game /etc/systemd/network/eth0.network"
    ]
  }

  provisioner "shell" {
    script = "./install_docker.sh"
  }
}
