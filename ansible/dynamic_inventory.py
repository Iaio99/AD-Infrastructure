#!/usr/bin/env python

import json
import sys


def main():
    with open('../configs.json', 'r') as f:
        configs = json.load(f)
        teams = configs["ad_platform"]["teams"]
        player_number = configs["ad_platform"]["player_number"]
        nodes = configs["incus_cluster"]["nodes"]
        remote = configs["incus_cluster"]["remote"]
        subnets = configs["ad_platform"]["subnet_ip"]
        ansible_user = configs["incus_cluster"]["ansible_user"]

    vulnboxes = ["nop-vulnbox"]
    vpns = []
    cluster_nodes = []
    nodes_names = dict()

    for n in nodes.keys():
        cluster_nodes.append(nodes[n])
        nodes_names[nodes[n]] = n

    cluster_address = cluster_nodes[0]

    if len(nodes) == 2:
        raise Exception("Cluster dimension cannot be 2")

    if len(nodes) == 1:
        inventory_cluster = {
            "cluster_nodes": {
                "hosts": cluster_nodes,
                "vars": {
                    "server_1": cluster_nodes[0],
                    "remote": remote,
                    "ansible_connection": "ssh",
                    "ansible_user": ansible_user
                }
            }
        }

    else: 
        inventory_cluster = {
            "cluster_nodes": {
                "hosts": cluster_nodes,
                "vars": {
                    "nodes_names": nodes_names,
                    "remote": remote,
                    "server_1": cluster_nodes[0],
                    "server_2": cluster_nodes[1],
                    "server_3": cluster_nodes[2],
                    "networks": subnets,
                    "ansible_connection": "ssh",
                    "ansible_user": ansible_user
                }
            }
        }


    for t in teams:
        vulnboxes.append(t + "-vulnbox")
        vpns.append(t + "-vpn")

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
                "endpoint_address": cluster_address,
                "vpn_players": player_number,
                "ansible_connection": "community.general.incus",
                "ansible_remote": remote
            }
        }
    }

    inventory.update(inventory_cluster)
    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
