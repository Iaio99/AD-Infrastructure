#!/usr/bin/env python

import json
import sys


def main():
    with open('../configs.json', 'r') as f:
        configs = json.load(f)
        teams = configs["ad-platform"]["teams"]
        player_number = configs["ad-platform"]["player_number"]
        nodes = configs["incus-cluster"]["nodes"]
        remote = configs["incus-cluster"]["remote"]

    vulnboxes = ["nop-vulnbox"]
    vpns = []
    hosts = []
    ovn_hosts = []

    for t in teams:
        vulnboxes.append(t+"-vulnbox")
        vpns.append(t+"-vpn")

    inventory = {
        "vulnboxes": {
            "hosts": vulnboxes,
            "vars": {
                "ansible_remote": remote,
                "ansible_connection": "community.general.incus"
            }
        },

        "vpns": {
            "hosts": vpns,
            "vars": {
                "endpoint_address": "192.168.142.111",
                "vpn_players": player_number,
                "ansible_connection": "community.general.incus",
                "ansible_remote": remote
            }
        }
    }

    for n in nodes.keys():
        hosts.append(n)
        ovn_hosts.append(nodes[n])

    if len(nodes) == 2:
        raise Exception("Cluster dimension cannot be 2")

    if len(nodes) == 1:
        inventory_cluster = {
            "nodes": {
                "hosts": hosts,
                "vars": {
                    "ansible_connection": "ssh"
                }
            },

            "ovn_hosts": {
                "hosts": ovn_hosts,
                "vars": {
                    "server_1": ovn_hosts[0],
                    "ansible_connection": "ssh"
                }
            },
        }

    else: 
        inventory_cluster = {
            "nodes": {
                "hosts": hosts,
                "ansible_connection": "ssh"
            },

            "ovn_hosts": {
                "hosts": ovn_hosts,
                "vars": {
                    "server_1": ovn_hosts[0],
                    "server_2": ovn_hosts[1],
                    "server_3": ovn_hosts[2],
                    "ansible_connection": "ssh"

                }
            },
        }
    inventory.update(inventory_cluster)
    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
