#!/bin/bash

machine="${1:-0}"
model="${2:-controller}"
juju=$(command -v juju)

read -d '' -r cmds <<'EOF'
conf=/var/lib/juju/agents/machine-*/agent.conf
user=$(sudo awk '/tag/ {print $2}' $conf)
password=$(sudo awk '/statepassword/ {print $2}' $conf)
client=$(command -v mongo)
"$client" 127.0.0.1:37017/juju --authenticationDatabase admin --ssl --sslAllowInvalidCertificates --username "$user" --password "$password"
EOF

"$juju" ssh -m "$model" "$machine" "$cmds"

