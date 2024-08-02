#/bin/bash
model=`juju show-model | head -n 1 | sed s/://`
if [ "$?" -eq "1" ]; then
	echo "No model?"
	exit 1
fi

# verify that if the controller is serverstack, then the OS_VARS are set.
juju controllers | grep "serverstack*" > /dev/null 2>&1
_IS_NOT_SERVERSTACK_CONTROLLER="$?"

# see whether the OS_VARS are set
_OS_REGION_NAME=$(env | grep OS_REGION_NAME | cut -d "=" -f 2)
# exit if this isn't running against serverstack
unset _OS_VARS
if [[ "xxx$_OS_REGION_NAME" == "xxxserverstack" ]]; then
	_OS_VARS=1
fi

# if it is serverstack and the OS vars aren't set, then bail out
if [[ "$_IS_NOT_SERVERSTACK_CONTROLLER" == "0" ]] && [[ -z "$_OS_VARS" ]]; then
	echo "controller is serverstack but OS_VARS are not set to serverstack"
	exit 1
fi

echo "Resetting $model"
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
	juju destroy-model $model -y --destroy-storage
	echo "Sleeping to allow juju to catch up and remove DB entry for $model"
	sleep 5
	juju add-model $model
	# determine whether we need to do serverstack stuff
	if [[ "$_IS_NOT_SERVERSTACK_CONTROLLER" == "1" ]]; then
		set-model-config.sh
	else
		echo "Doing serverstack model config"
		set-serverstack-model-config.sh
	fi
	echo "Done!"
else
	echo "Doing nothing."
fi

