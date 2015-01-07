#!/bin/bash
CL_D="\[\e[m\]"
CL_R="\[\e[0;31m\]"
CL_G="\[\e[0;32m\]"
CL_B="\[\e[0;34m\]"
#CL_W="\[\e[1;37m\]"
ON_R="\[\e[41m\]"
export PROMPT_COMMAND='ERR=$?'
ERR="\$([[ \$ERR != 0 ]] && echo ${ON_R})\$(printf '%3i' \$ERR)${CL_D}"
USR="${CL_G}\\u${CL_D}"
HST="${CL_R}\\h${CL_D}"
WRK="${CL_B}\\w${CL_D}"
export PS1="${ERR} ${USR}@${HST}:${WRK}"'\$'

export DISPLAY=:0.0

export LANG=C
export LC_ALL=C
export LC_CTYPE=C

alias ls='ls --color -Fh'
alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'

export EDIT=notepad++
export EDITOR=$EDIT
export VISUAL=$EDIT
alias st='git status'
alias gd='git diff --ignore-space-change --color-words'
alias gk='gitk --all &'
alias gp='git pull && git push'

#http://stackoverflow.com/a/16178979
color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

err()(echo $@ >&2)

#http://stackoverflow.com/a/13701495/321973
winpath2posix() (echo /$@ | sed -e 's/\\/\//g' -e 's/://')

case $(uname -s) in
	CYGWIN*)
		alias grep='grep --color=auto'
		edit() (notepad++ $(cygpath -w $@))
		
		export EPREFIX="/gentoo"
		#export OVERLAY="/overlay"
		export WINPATH="${PATH}"
		export PATH=$(echo ${PATH} | awk -v RS=: -v ORS=: '/cygdrive/ {next} {print}' | sed 's/:*$//')
		export PATH="/usr/local/bin:/usr/bin:/bin:${PATH}"
		export PATH="${EPREFIX}/lib:${EPREFIX}/usr/lib:${EPREFIX}/usr/bin:${EPREFIX}/bin:${EPREFIX}/tmp/usr/bin:${EPREFIX}/tmp/bin:${PATH}"
		export PATH="${HOME}/pkg/sbin:${HOME}/pkg/bin:${PATH}"
		export MANPATH="${HOME}/pkg/man:${MANPATH}"
		#export PKG_DBDIR="${HOME}/pkg/var"
		;;
	MINGW*)
		alias edit=$EDIT
		export SSH_AUTH_SOCK="$(winpath2posix "$SSH_AUTH_SOCK")"
		;;
	*)
		err "Unhandled system: " $(uname -s)
esac
