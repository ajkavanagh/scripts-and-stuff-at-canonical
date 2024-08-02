#/bin/bash

# pesci '*' in juju lines meaning "selected" model end up globbing in the script
set -o noglob

function set_juju_version {
	local v
	v=$(juju version | grep -e "^3")
	if [ "?$" == "0" ]; then
		JUJU_VERSION=2
	else
		JUJU_VERSION=3
	fi
}

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
	set_juju_version
	if [ "$JUJU_VERSION" == "2" ]; then
		juju destroy-model $model -y --destroy-storage --force
	else
		juju destroy-model --no-prompt "$model" --destroy-storage --force
	fi
	echo "Done!"
else
	echo "Doing nothing."
fi

