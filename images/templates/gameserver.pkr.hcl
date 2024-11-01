source "incus" "faust_gameserver" {
  image = "images:debian/12"
  output_image = "faust_gameserver"
  container_name = "${local.config.incus-cluster.remote}:faust_gameserver"
  reuse = true
  publish_remote_name = local.config.incus-cluster.remote

  publish_properties =  {
    description = "Image for the faust_gameserver"
  }
}

build {
  sources = ["source.incus.faust_gameserver"]

  provisioner "shell" {
    inline  = [
      "echo 'deb-src http://deb.debian.org/debian bookworm main non-free-firmware' >> /etc/apt/sources.list",
      "apt-get update -y",
      "apt-get install -y apt-utils",
      "apt-get upgrade -y",
      "apt-get install -y python3 bash-completion openssh-server sudo python-is-python3 nginx uwsgi uwsgi-plugin-python3",
      "apt-get install -y devscripts dpkg-dev equivs",
      "git clone https://github.com/fausecteam/ctf-gameserver.git /tmp/ctf-gameserver",
      "cd /tmp/ctf-gameserver",
      "mk-build-deps --install debian/control --tool 'apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y'",
      "dpkg-buildpackage --unsigned-changes --unsigned-buildinfo",
      "mv ../ctf-gameserver_1.0_all.deb /root",
      "apt-get purge -y devscripts dpkg-dev equivs"
    ]
  }
  provisioner "ansible" {
    playbook_file = "{path.root}/../files/gameserver/playbook.yml
    inventory_file = "{path.root}/../files/gameserver/inventory
  }
}
