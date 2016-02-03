#! /usr/bin/env bash

# From: http://unix.stackexchange.com/questions/200225/search-history-from-multiple-bash-session-only-when-ctrl-r-is-used-not-when-a

# Point hh to global history
export HISTFILE=~/.bash_history.global

# Install: hh
# Reverse search
hh

# Restore local history
export HISTFILE=~/.bash_history 
