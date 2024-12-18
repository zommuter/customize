#!/bin/bash

# https://unix.stackexchange.com/a/18443/863
HISTFILESIZE=5000
HISTSIZE=5000
#HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
# https://askubuntu.com/a/318746/929
shopt -s direxpand
PROMPT_COMMAND="$PROMPT_COMMAND;history -n; history -w; history -c; history -r"