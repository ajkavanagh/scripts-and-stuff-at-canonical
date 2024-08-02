#!/bin/bash

echo "Delete all of the juju named ports?"

show-os-vars.sh
echo
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ $response =~ ^(yes|y)$ ]]
then
	for id in $(openstack port list -c ID -c Name -f value | grep "juju" | awk '{print $1}')
	do
		echo "Deleting port: $id"
		openstack port delete $id
	done
fi
