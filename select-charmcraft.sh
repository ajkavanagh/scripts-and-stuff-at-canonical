#!/usr/bin/env bash

if [ ! -f 'osci.yaml' ]; then
    echo "No osci.yaml - bailing out."
    exit 1
fi

YQ=`which yq`

if [ -z "$YQ" ]; then
    echo "No yq - you need it installed for this app."
    exit 2
fi


# get the current snap version
snap_version=$(snap info charmcraft | $YQ ".tracking")

# now read the charmcraft version from osci.yaml
osci_version=$(yq '.[].project.vars.charmcraft_channel // "1.5/stable"' osci.yaml)

if [ "$snap_version" != "$osci_version" ]; then
    echo "Installing charmcraft $osci_version";
    sudo snap refresh charmcraft --channel=$osci_version
else
    echo "Versions match: $osci_version"
fi
