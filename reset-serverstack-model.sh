#/bin/bash
model=`juju show-model | head -n 1 | sed s/://`
if [ "$?" -eq "1" ]; then
	echo "No model?"
	exit 1
fi

echo "Resetting $model"
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
	juju destroy-model $model -y
	juju add-model $model
	set-serverstack-model-config.sh
	echo "Done!"
else
	echo "Doing nothing."
fi

