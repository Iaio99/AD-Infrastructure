resource "incus_instance" "gameserver" {
  name  = "gameserver"
  image = "faust-gameserver"
  profiles = ["default"]
  remote = var.remote
  project = var.project_name

  device {
    name = "eth0"
    type = "nic"
    properties = {
      "network" = "gameserver-network"
      "ipv4.address" = "10.10.0.1"
    }
  }

  device {
    name = "http-proxy"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:80"
      connect = "tcp:10.10.0.1:80"
    }
  }

  config = {
    "boot.autostart" = true
  }

  type = var.instance_type
}

resource "incus_instance" "vulnbox" {
  count = length(var.teams)

  name  = "${var.teams[count.index]}-vulnbox"
  image = "vulnbox"
  profiles = ["default"]
  remote = var.remote
  project = var.project_name

  config = {
    "boot.autostart" = true
    "security.nesting" = true
    "security.syscalls.intercept.mknod" = true
    "security.syscalls.intercept.setxattr" = true
  }

  device {
    name = "game0"
    type = "nic"
    properties = {
      "name" = "game0"
      "network" = "vulnboxes-network"
      "ipv4.address" = "10.60.${count.index}.1"
    }
  }
  
  type = var.instance_type
}

resource "incus_instance" "vpn" {
  count = length(var.teams)

  name  = "${var.teams[count.index]}-vpn"
  image = "wireguard"
  profiles = ["default"]
  remote = var.remote
  project = var.project_name

  config = {
    "boot.autostart" = true
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      "name" = "eth0"
      "network" = "vpn-servers-network"
      "ipv4.address" = "10.80.${count.index}.254"
    }
  }

  device {
    name = "wireguard-proxy"
    type = "proxy"
    properties = {
      listen = "udp:0.0.0.0:${51820+count.index}"
      connect = "udp:10.80.${count.index}.254:51820"
    }
  }

  wait_for_network = false

  type = var.instance_type
}
