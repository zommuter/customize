#!/bin/bash
#LANG=C
#LC_ALL=$LANG
#LC_CTYPE=C

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
		EDIT=notepad++
		EDITOR=$EDIT
		VISUAL=$EDIT
		;;
	MINGW*|MSYS*)
		#SSH_AUTH_SOCK="$(winpath2posix "$SSH_AUTH_SOCK")"
		EDIT=notepad++
		;;
	Linux*)
		EDIT=nano
		export DISPLAY="$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0"
		export LIBGL_ALWAYS_INDIRECT=1
		;;
	*)
		err "Unhandled system: " $(uname -s)
esac

alias edit=$EDIT
EDITOR=$EDIT
VISUAL=$EDIT

alias cdp='cd "$USERPROFILE/Documents/Pandoc/"'
alias cds='cd "$USERPROFILE/Documents/src/"'
alias cdd='cd "$USERPROFILE/Documents/"'
alias cdt='cd "$USERPROFILE/Documents/tmp/"'
alias cde='cd /g/Entwicklung'

alias pi.docker='docker -H ssh://pi'
alias ike.docker='docker -H ssh://ike'

alias pcat="pygmentize -g"
pless() (pygmentize -g $@ | less)
zlipd() (printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |cat - $@ |gzip -dc)

export HOME=${HOME%%/}  # remove accidental trailing slash
#eval $(dircolors ~/customize/dircolors-solarized/dircolors.ansi-light)

# https://stackoverflow.com/a/7110386/321973
#trap 'echo -ne "\033]0;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

alias cnf="pacman -F"
#alias ofoam="source /opt/OpenFOAM/OpenFOAM-v1912/etc/bashrc"
#source /opt/OpenFOAM/OpenFOAM-v1912/etc/bashrc

# https://wiki.archlinux.org/index.php/Color_output_in_console
alias diff='diff --color=auto'
alias grep='grep --color=auto'
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# try the shared socket first, only spawn a local agent on failure
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
#if [ -z ${SSH_AUTH_SOCK:+x} ] ; then
if ! $(ssh-add -l > /dev/null 2>&1) ; then
  eval $(ssh-agent) > /dev/null 2>&1
  if [ -f ~/.ssh/id_rsa ] ; then
    cat ~/.ssh/id_rsa | ssh-add -k -
  fi
  ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

alias ofoam="source /opt/OpenFOAM/OpenFOAM-v2006/etc/bashrc"
alias of="source /opt/OpenFOAM/OpenFOAM-v2006/etc/bashrc"
alias paraFoam="paraFoam -builtin"

npp ()(notepad++.exe $(readlink -f "$1") &)
delink ()(cp --remove-destination "$(readlink -f ""$1"")" "$1")
