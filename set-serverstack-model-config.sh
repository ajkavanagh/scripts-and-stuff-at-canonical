#!/bin/bash

set -e

if [[ -z "SERVERSTACK_PREFIX" ]]; then
	echo "Sorry, SERVERSTACK_PREFIX is not configured?"
	exit 1
fi

NETWORK_NAME="${SERVERSTACK_PREFIX}_admin_net"

_OS_REGION_NAME=$(env | grep OS_REGION_NAME | cut -d "=" -f 2)
# exit if this isn't running against serverstack
if [[ "xxx$_OS_REGION_NAME" != "xxxserverstack" ]]; then
	echo "OS_* vars aren't for serverstack"
	exit 1
fi

NETWORK=$(openstack network list -f value | grep $NETWORK_NAME | cut -d " " -f 1)

juju model-config image-stream=daily
juju model-config test-mode=true
juju model-config transmit-vendor-metrics=false
juju model-config enable-os-refresh-update=false
juju model-config enable-os-upgrade=false
juju model-config automatically-retry-hooks=false
juju model-config network=$NETWORK
# might need this off if we've disabled port security -- let's do it automatically.

eval $(openstack network show $NETWORK -f shell | grep port_security_enabled)
if [ "xxx$port_security_enabled" == "xxxTrue" ]; then
	echo "Setting use-default-secgroup=true"
	juju model-config use-default-secgroup=true
fi
juju set-model-constraints virt-type=kvm
