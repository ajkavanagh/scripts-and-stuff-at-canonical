#!/usr/bin/env python3

import subprocess
import json
import pprint
import sys


def read_juju_models():
    """Read the existing models, ignoring the controller"""
    cmd = "juju models --format=json"
    result = json.loads(subprocess.check_output(cmd.split()).decode("UTF-8"))
    models = [i['short-name'] for i in result['models']]
    return models


def new_smart_juju_model(name):
    """Create a new model using the following constraints

    juju add-model $model
    juju model-defaults image-stream=daily
    juju model-defaults test-mode=true
    juju model-defaults transmit-vendor-metrics=false
    juju model-defaults enable-os-refresh-update=false
    juju model-defaults enable-os-upgrade=false
    juju model-defaults automatically-retry-hooks=false
    """
    def run_cmd(cmd):
        subprocess.check_call(cmd.split())

    run_cmd("juju add-model {}".format(name))
    run_cmd("juju model-defaults image-stream=daily")
    run_cmd("juju model-defaults test-mode=true")
    run_cmd("juju model-defaults transmit-vendor-metrics=false")
    run_cmd("juju model-defaults enable-os-refresh-update=false")
    run_cmd("juju model-defaults enable-os-upgrade=false")
    run_cmd("juju model-defaults automatically-retry-hooks=false")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: {} <model-name>".format(sys.argv[0]))
        sys.exit(1)
    models = read_juju_models()
    new_model_name = sys.argv[1]
    if new_model_name in models:
        print("ERROR: model '{}' already exists".format(new_model_name))
        sys.exit(1)
    new_smart_juju_model(new_model_name)
    print("Created model: {}".format(new_model_name))
