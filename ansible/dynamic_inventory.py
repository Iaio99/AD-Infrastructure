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
                "ctf_gameserver_web_allowed_hosts": ["{{ ansible_fqdn }}", "192.168.142.111"]
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
