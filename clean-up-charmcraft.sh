#/usr/bin/env bash

# clean-up charmcraft builds on lxc
CHARMCRAFT=$(which charmcraft)
if [[ ! -z "$CHARMCRAFT" ]]; then
	LXC=$(which lxc)
	if [[ ! -z "$LXC" ]]; then
		containers=$($LXC list --project charmcraft --format csv)
		for container in $containers; do
			name=$(echo $container | cut -d "," -f 1)
			echo "Deleting container $name"
            $LXC delete -f --project charmcraft $name
		done
	fi
fi
