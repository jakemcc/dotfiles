#!/bin/bash

set -e

DIRECTORY="$HOME/org/"

stderr () {
    echo "$1" >&2
}

is_command() {
	  which "$1" &>/dev/null
}

for cmd in "git" "fswatch"; do
    is_command $cmd || { stderr "Error: Required command '$cmd' not found"; exit 1; }
done

while true; do
    fswatch --one-event --recursive --exclude '\.git/' --exclude '\.#.*' "$DIRECTORY"
    sleep 5
    cd "$DIRECTORY"
    STATUS=$(git status -s)
    if [ -n "$STATUS" ]; then
        echo $STATUS
        echo "commit!"
        git add .
        git commit -m "autocommit"
        git push origin
    fi
done
