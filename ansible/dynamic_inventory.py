#!/usr/bin/env python

import json
import sys


def main():
    with open('../configs.json', 'r') as f:
        configs = json.load(f)
        teams = configs["ad-platform"]["teams"]
        player_number = configs["ad-platform"]["player_number"]
        nodes = json.load(f)["incus-cluster"]["nodes"]
        

    vulnboxes = ["nop-vulnbox"]
    vpns = []
    hosts = []
    ovn_hosts = []


    for t in teams:
        vulnboxes.append(t+"-vulnbox")
        vpns.append(t+"-vpn")

    inventory = {
        "vulnboxes": {
            "hosts": vulnboxes
            "vars": {
                "ansible_remote": remote
                "ansible_connection": "community.general.incus",
            }
        },

        "vpns": {
            "hosts": vpns,
            "vars": {
                "endpoint_address": "192.168.142.111",
                "vpn_players": player_number
                "ansible_connection": "community.general.incus",
                "ansible_remote": remote
            }
        },

        "gameserver": {
            "hosts": ["gameserver"],
            "vars": {
                "ctf_gameserver_downloadpath": "file:///root/",
                "ctf_gameserver_db_pass_web": "password",
                "ctf_gameserver_db_pass_controller": "password",
                "ctf_gameserver_db_pass_submission": "password",
                "ctf_gameserver_db_pass_checker": "password",
                "ctf_gameserver_db_pass_vpnstatus": "password",
                "ctf_gameserver_web_admin_email": "admin@example.org",
                "ctf_gameserver_web_admin_pass": "admin",
                "ctf_gameserver_web_from_email": "sender@example.org",
                "ctf_gameserver_web_secret_key": "ZytYXi50TV9NSmtiQjlpTXh1WkNYKzI4fnQxXytYLzk=",
                "ctf_gameserver_web_timezone": "Europe/Rome",
                "ctf_gameserver_checker_ippattern": "10.60.%.1",
                "ctf_gameserver_flag_secret": "WHc5fF8jV2dnUnB5bS1mXS48KD1BfTdRLTtRYihAfFA=",
                "ctf_gameserver_submission_listen_host": "0.0.0.0",
                "ctf_gameserver_submission_listen_ports": [8080],
                "ctf_gameserver_db_user_vpnstatus": "gameserver_vpnstatus",
                "ctf_gameserver_web_allowed_hosts": ["{{ ansible_fqdn }}", "192.168.142.111"],
                "ansible_connection": "community.general.incus",
                "ansible_remote": remote
            }
        }
    }

    for n in nodes.keys():
        hosts.append(n)
        ovn_hosts.append(nodes[n])

    if len(nodes) == 2:
        raise Exception "Cluster dimension cannot be 2"

    if len(nodes) == 1:
        inventory += {
            "nodes": {
                "hosts": hosts,
                "ansible_connection": "ssh"
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
        inventory += {
            "nodes": {
                "hosts": hosts
                "ansible_connection": "ssh",
            },

            "ovn_hosts": {
                "hosts": ovn_hosts,
                "vars": {
                    "server_1": ovn_hosts[0],
                    "server_2": ovn_hosts[1],
                    "server_3": ovn_hosts[2],
                    "ansible_connection": "ssh",

                }
            },
        }

    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
