#!/bin/bash

echo "Delete all of the juju named security groups?"

show-os-vars.sh
echo
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ $response =~ ^(yes|y)$ ]]
then
	for id in $(openstack security group list -c ID -c Name -f value | grep "juju" | awk '{print $1}')
	do
		echo "Deleting group: $id"
		openstack security group delete $id
	done
fi
