#!/bin/bash

set -e

juju model-defaults image-stream=daily
juju model-defaults test-mode=true
juju model-defaults transmit-vendor-metrics=false
juju model-defaults enable-os-refresh-update=false
juju model-defaults enable-os-upgrade=false
juju model-defaults automatically-retry-hooks=false

if [[ -z "SERVERSTACK_PREFIX" ]]; then
	echo "Sorry, SERVERSTACK_PREFIX is not configured?"
	exit 1
fi

NETWORK_NAME="${SERVERSTACK_PREFIX}_admin_net"

eval $(openstack network show $NETWORK_NAME -f shell | grep port_security_enabled)
if [ "xxx$port_security_enabled" == "xxxTrue" ]; then
	echo "Setting use-default-secgroup=true"
	juju model-config use-default-secgroup=true
fi
juju set-model-constraints virt-type=kvm
