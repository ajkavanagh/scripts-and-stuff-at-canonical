#!/bin/bash

set -e

juju model-defaults image-stream=daily
juju model-defaults test-mode=true
juju model-defaults transmit-vendor-metrics=false
juju model-defaults enable-os-refresh-update=false
juju model-defaults enable-os-upgrade=false
juju model-defaults automatically-retry-hooks=false
