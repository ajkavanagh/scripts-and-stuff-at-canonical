#!/bin/bash

# pesci '*' in juju lines meaning "selected" model end up globbing in the script
set -o noglob

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

echo "Which model to switch to?\n"

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

juju switch $model
juju models
