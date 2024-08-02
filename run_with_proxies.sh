#/bin/bash
# we want http proxies for all of our shells in the bastion
export http_proxy=http://squid.internal:3128/
export https_proxy=https://squid.internal:3128/
# now run what every command it was with this new environment
$*
