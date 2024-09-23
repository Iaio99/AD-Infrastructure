#!/usr/bin/env python

import json
import sys


def main():
    with open('../configs.json', 'r') as f:
        teams = json.load(f)["teams"]

    vulnboxes = ["nop-vulnbox"]
    vpns = ["nop-vpn"]

    for t in teams:
        vulnboxes.append(t+"-vulnbox")
        vpns.append(t+"-vpn")

    inventory = {
        "vulnboxes": {
            "hosts": vulnboxes
        },

        "vpns": {
            "hosts": vpns,
            "vars": {
                "endpoint_address": "192.168.142.111",
                "players": 6
            }
        },

        "all": {
            "vars": {
                "ansible_connection": "community.general.incus",
                "ansible_remote": "local"
            }
        }
    }

    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
