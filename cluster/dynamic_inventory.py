#!/usr/bin/env python

import json
import sys


def main():
    with open('../configs.json', 'r') as f:
        nodes = json.load(f)["incus-cluster"]["nodes"]

    hosts = []
    ovn_hosts = []

    for n in nodes.keys():
        hosts.append(n)
        ovn_hosts.append(nodes[n])

    inventory = {
        "nodes": {
            "hosts": hosts
        },

        "ovn_hosts": {
            "hosts": ovn_hosts,
            "vars": {
                "server_1": ovn_hosts[0],
                "server_2": ovn_hosts[1],
                "server_3": ovn_hosts[2]
            }
        },
        "all": {
            "vars": {
                "ansible_connection": "ssh",
            }
        }
    }

    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
