source "incus" "vulnbox" {
  image = "images:debian/12"
  output_image = "vulnbox"
  reuse = true
  profile = "build"

  publish_properties =  {
    description = "Image for the servers where the vulnerable services will be hosted"
  }

  launch_config = {
    "security.nesting" = true
    "security.syscalls.intercept.mknod" = true
    "security.syscalls.intercept.setxattr" = true
  }
}

build {
  sources = ["source.incus.vulnbox"]

  provisioner "shell" {
    inline  = [
      "apt-get install -y apt-utils",
      "apt-get install -y sudo python-is-python3 python3 cron vim tcpdump tmux bash-completion openssh-server nano file utils-linux openssh-sftp-server",
      "sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config",
      "sed -i 's/^Name=eth0/Name=game0/' /etc/systemd/network/eth0.network",
      "rename.ul eth0 game0 /etc/systemd/network/eth0.network",
      "echo 'PermitRootLogin yes' > /etc/ssh/sshd_config"
    ]
  }

  provisioner "file" {
    source = "${path.root}/../files/services/"
    destination = "/root"
  }

  provisioner "shell" {
    inline = ["chown -R root:root /root"]
  }

  provisioner "shell" {
    script = "${path.root}/../scripts/install_docker.sh"
  }

  provisioner "shell" {
    script = "${path.root}/../scripts/setup_services.sh"
  }
}
