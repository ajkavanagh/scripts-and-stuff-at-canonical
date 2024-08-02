#/bin/bash

models=`juju models | grep -e "^zaza-" | cut -d " " -f 1 | sed -s "s/\*//"`
if [ "$?" -eq "1" ]; then
	echo "No models?"
	exit 1
fi

echo "Killing: $models"
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
	while read -r model; do
		juju destroy-model $model -y --destroy-storage
	done <<< "$models"
else
	echo "Doing nothing."
fi

