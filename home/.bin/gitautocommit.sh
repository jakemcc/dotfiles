#!/bin/bash

set -e

TARGETDIR="$HOME/org/"

stderr () {
    echo "$1" >&2
}

is_command() {
	  which "$1" &>/dev/null
}

if [ -z "$GW_INW_BIN" ]; then
    # if Mac, use fswatch
    if [ "$(uname)" != "Darwin" ]; then
        INW="inotifywait";
        EVENTS="close_write,move,delete,create";
    else
        INW="fswatch";
        # default events specified via a mask, see
        # https://emcrisostomo.github.io/fswatch/doc/1.14.0/fswatch.html/Invoking-fswatch.html#Numeric-Event-Flags
        # default of 414 = MovedTo + MovedFrom + Renamed + Removed + Updated + Created
        #                = 256 + 128+ 16 + 8 + 4 + 2
        EVENTS="--event=414"
    fi;
else
    INW="$GW_INW_BIN";
fi

for cmd in "git" "$INW" "timeout"; do
    is_command "$cmd" || { stderr "Error: Required command '$cmd' not found"; exit 1; }
done

if [ "$(uname)" != "Darwin" ]; then
  INCOMMAND="\"$INW\" -qmr -e \"$EVENTS\" --exclude \"\.git\" \"$TARGETDIR\""
else
  # still need to fix EVENTS since it wants them listed one-by-one
  INCOMMAND="\"$INW\" --recursive \"$EVENTS\" --exclude \"\.git\" \"$TARGETDIR\""
fi

cd "$TARGETDIR"

while true; do
    eval "timeout 600 $INCOMMAND" || true
    git pull
    sleep 5
    STATUS=$(git status -s)
    if [ -n "$STATUS" ]; then
        echo "$STATUS"
        echo "commit!"
        git add .
        git commit -m "autocommit"
        git push origin
    fi
done
