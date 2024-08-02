#/usr/bin/env bash
# clean up python runtime, .tox, .venv, etc.

find . -name '.tox' -prune -exec rm -rf "{}" \;
find . -iname '.venv*' -prune -exec rm -rf "{}" \;
find . -name '.testrepository' -prune -exec rm -rf "{}" \;
find . -name '*.egg-info' -prune -exec rm -rf "{}" \;
find . -name '.eggs' -prune -exec rm -rf "{}" \;
find . -name '__pycache__' -prune -exec rm -rf "{}" \;
find . -name '.stestr' -prune -exec rm -rf "{}" \;
find . -iname '*.pyc' -delete
find . -name 'func-results.json' -delete
find . -type d -name '.stack-work' -prune -exec rm -rf "{}" \;

# clean up the builds of charms too
# 1. reactive/.*/build/builds is above the current directory
find . -type d | egrep "/reactive/,*/build$" | xargs rm -rf
# 2. /reactive is below and build/builds is above the current directory
pwd | egrep "/reactive(/|$)" && find . -type d | egrep "/build$" | xargs rm -rf

# cleanup rust targets
# 1. rust directory is above the current directory
pwd | egrep "/rust(/|$)" && find -name 'target' -type d -prune -exec rm -rf "{}" \;
# 2. rust directory is below the current directory
find -name 'target' -type d | egrep "/rust/" | xargs rm -rf

CLEANUP_CHARMCRAFT=$(which clean-up-charmcraft.sh)
if [[ ! -z "$CLEANUP_CHARMCRAFT" ]]; then
    $CLEANUP_CHARMCRAFT
fi
