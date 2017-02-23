#!/bin/bash
CL_D="\[\e[m\]"
CL_R="\[\e[0;31m\]"
CL_G="\[\e[0;32m\]"
CL_B="\[\e[0;34m\]"
#CL_W="\[\e[1;37m\]"
ON_R="\[\e[41m\]"
PROMPT_COMMAND="ERL=\$?"

# https://unix.stackexchange.com/a/18443/863
HISTFILESIZE=5000
HISTSIZE=5000
#HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="$PROMPT_COMMAND;history -n; history -w; history -c; history -r"

ERR="\$([[ \$ERL != 0 ]] && echo ${ON_R})\$(printf '%3i' \$ERL)${CL_D}"
USR="${CL_G}\\u${CL_D}"
HST="${CL_R}\\h${CL_D}"
WRK="${CL_B}\\w${CL_D}"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
# Explicitly unset color (default anyhow). Use 1 to set it.
GIT_PS1_SHOWCOLORHINTS=
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git verbose"
if [ $(type -t __git_ps1) ]; then  # check if __git_ps1 actually exists!
	GIT="${CL_G}"'$(__git_ps1)'"${CL_D}"
else
	GIT=""
fi

PS1="${ERR} ${USR}@${HST}:${WRK}${GIT}"'\$'
PS1="\[\e]0;\${ERL} \u@\h: \w\007\]${PS1}"

DISPLAY=:0.0

#LANG=C
#LC_ALL=$LANG
#LC_CTYPE=C

alias ls='ls --color -Fh'
alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'

EDIT=notepad++
EDITOR=$EDIT
VISUAL=$EDIT
alias st='git status'
#alias gd='git diff --ignore-space-change --color-words'
#alias gd='git diff --ignore-space-change --word-diff-regex=.'

#https://stackoverflow.com/a/25634420/321973
alias gd="git diff --color-words='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'"
alias gdp="git diff --color-words='[[:space:]]|([[:alnum:]]|UTF_8_GUARD)+' --word-diff=plain"

alias gk='gitk --all &'
#alias gp='[[ $(git pull) == "Already up-to-date." ]] || git push'
alias gp='git pull --rebase && git push'

#http://stackoverflow.com/a/16178979
color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

err()(echo $@ >&2)

#http://stackoverflow.com/a/13701495/321973
winpath2posix() (echo /$@ | sed -e 's/\\/\//g' -e 's/://')

case $(uname -s) in
	CYGWIN*)
		alias grep='grep --color=auto'
		edit() (notepad++ $(cygpath -w $@))
		
		EPREFIX="/gentoo"
		#OVERLAY="/overlay"
		WINPATH="${PATH}"
		PATH=$(echo ${PATH} | awk -v RS=: -v ORS=: '/cygdrive/ {next} {print}' | sed 's/:*$//')
		PATH="/usr/local/bin:/usr/bin:/bin:${PATH}"
		PATH="${EPREFIX}/lib:${EPREFIX}/usr/lib:${EPREFIX}/usr/bin:${EPREFIX}/bin:${EPREFIX}/tmp/usr/bin:${EPREFIX}/tmp/bin:${PATH}"
		PATH="${HOME}/pkg/sbin:${HOME}/pkg/bin:${PATH}"
		MANPATH="${HOME}/pkg/man:${MANPATH}"
		#PKG_DBDIR="${HOME}/pkg/var"
		;;
	MINGW*|MSYS*)
		alias edit=$EDIT
		SSH_AUTH_SOCK="$(winpath2posix "$SSH_AUTH_SOCK")"
		;;
	*)
		err "Unhandled system: " $(uname -s)
esac
#alias cdi='cd /g/TD/kit/InDesign/Templates/'
alias cdi='cd /g/TD/VORLAGEN/2017-InDesign/Template/'
alias cdp='cd $USERPROFILE/Documents/Pandoc/'
alias cds='cd $USERPROFILE/Documents/src/'
alias cdd='cd $USERPROFILE/Documents/'
alias cdg='cd /g/TD/kit/git.repositories/'
alias cdt='cd $USERPROFILE/Documents/tmp/'

alias pcat="pygmentize -g"
pless() (pygmentize -g $@ | less)
zlipd() (printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |cat - $@ |gzip -dc)

HOME=${HOME%%/}  # remove accidental trailing slash

# https://stackoverflow.com/a/7110386/321973
trap 'echo -ne "\033]0;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG
