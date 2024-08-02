#!/usr/bin/env python3

import yaml
import subprocess
import sys


def run_cmd(cmd):
    cs = cmd.split(" ")
    try:
        output = subprocess.check_output(cs).decode('utf-8')
        return output
    except subprocess.CalledProcessError() as e:
        print(f"command '{cmd}' failed with '{e}'.")
        sys.exit(1)


def main():
    status = run_cmd("juju status --format=yaml")
    yml = yaml.safe_load(status)
    for app, app_data in yml['applications'].items():
        config = run_cmd(f"juju config {app} --format=yaml")
        cfg_yaml = yaml.safe_load(config)['settings']
        ks = cfg_yaml.keys()
        if 'openstack-origin' in ks:
            version = cfg_yaml['openstack-origin']['value']
        elif 'source' in ks:
            version = cfg_yaml['source']['value']
        else:
            version = "<not known>"
        print(f"app: {app:25} origin: {version}")


if __name__ == '__main__':
    main()
