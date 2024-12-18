#!/bin/bash

alias ls='ls --color -Fh'
alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'

alias stu='git status'
alias st='git status -uno'
#https://stackoverflow.com/a/25634420/321973
alias gd="git diff --color-words='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'"
alias gdp="git diff --color-words='[[:space:]]|([[:alnum:]]|UTF_8_GUARD)+' --word-diff=plain"

alias gk='gitk --all &'
alias gp='git pull --rebase && git push'

alias cdp='cd "$USERPROFILE/Documents/Pandoc/"'
alias cds='cd "$USERPROFILE/Documents/src/"'
alias cdd='cd "$USERPROFILE/Documents/"'
alias cdt='cd "$USERPROFILE/Documents/tmp/"'

alias pcat="pygmentize -g"
pless() (pygmentize -g $@ | less)
zlipd() (printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |cat - $@ |gzip -dc)

#alias cnf="pacman -F"
#alias ofoam="source /opt/OpenFOAM/OpenFOAM-v1912/etc/bashrc"
#source /opt/OpenFOAM/OpenFOAM-v1912/etc/bashrc

#alias ofoam="source /opt/OpenFOAM/OpenFOAM-v2006/etc/bashrc"
#alias of="source /opt/OpenFOAM/OpenFOAM-v2006/etc/bashrc"
#alias paraFoam="paraFoam -builtin"

npp ()(notepad++.exe $(readlink -f "$1") &)
delink ()(cp --remove-destination "$(readlink -f ""$1"")" "$1")
