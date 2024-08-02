#/bin/bash

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

function get_models {
	local IFS=$'\n'
	models=(`juju models`)
	local i
	local j
	for (( i=2; i<${#models[@]}; i++ )) ; do
		j=$(( $i-1 ))
		echo "$j: ${models[$i]}"
	done
}

echo "Which model to destroy?\n"

get_models
len=$(( ${#models[@]} -2 ))

read -r -p "Choose: 1..$len:" response

if (( $response < 1 || $response > $len )); then
	echo "$response is not in range 1..$len"
	exit 1
fi

index=$(($response+1))
line=${models[$index]}
model=`echo $line | egrep "^\w+" | cut -d " " -f 1 | sed -s "s/\*//"`

echo "Destroying $model"
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
	juju destroy-model $model -y --destroy-storage
	echo "Done!"
else
	echo "Doing nothing."
fi

