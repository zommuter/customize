
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
# https://askubuntu.com/a/318746/929
shopt -s direxpand
PROMPT_COMMAND="$PROMPT_COMMAND;history -n; history -w; history -c; history -r"

ERR="\$([[ \$ERL != 0 ]] && echo ${ON_R})\$(printf '%3i' \$ERL)${CL_D}"
#USR="${CL_G}\\u${CL_D}"
#HST="${CL_R}\\h${CL_D}"
#WRK="${CL_B}\\w${CL_D}"

hash2rgb()
{
  HASH=$(echo $1 | sha1sum)
  C=$((16#${HASH:0:2}/2))
  M=$((16#${HASH:2:2}/2))
  Y=$((16#${HASH:4:2}/2))
  R=$((256-$C))
  G=$((256-$M))
  B=$((256-$Y))
  FG="\e[38;2;${R};${G};${B}m"
  BG="\e[48;2;${C};${M};${Y}m"
  echo "\[${FG}${BG}\]"
}

CL_HST=$(hash2rgb $HOSTNAME)
HST="${CL_HST}\\h${CL_D}"

CL_USR=$(hash2rgb $USER)
USR="${CL_USR}\\u${CL_D}"

PWD_COLOR=auto
PROMPT_COMMAND="$PROMPT_COMMAND
  CL_WRK=\"\\$(echo ${CL_B})\"
  [ \"\$PWD_COLOR\" = \"auto\" ] && CL_WRK=\$(hash2rgb \$PWD)"
WRK="\${CL_WRK}\\w${CL_D}"

source /usr/share/git/completion/git-prompt.sh

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

CL_HSTUSR=$(hash2rgb $USER@$HOSTNAME)
PS1="${ERR} ${USR}@${HST}${CL_HSTUSR}:${CL_D}${WRK}${GIT}${CL_HSTUSR}"'\$'"${CL_D}"
#PS1="${ERR} ${USR}@${HST}:${WRK}${GIT}"'\$'
PS1="\[\e]0;\${ERL} \u@\h: \w\007\]${PS1}"

PS1_TEMPLATE="$PS1"
PROMPT_COMMAND="$PROMPT_COMMAND;PS1=\"$(echo ${PS1_TEMPLATE})\""

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

if [ -f "${HOME}/.bash_completion" ] ; then
  source "${HOME}/.bash_completion"
fi

alias edit=$EDIT
EDITOR=$EDIT
VISUAL=$EDIT

alias cdp='cd "$USERPROFILE/Documents/Pandoc/"'
alias cds='cd "$USERPROFILE/Documents/src/"'
alias cdd='cd "$USERPROFILE/Documents/"'
alias cdt='cd "$USERPROFILE/Documents/tmp/"'
alias cde='cd /g/Entwicklung'

alias pcat="pygmentize -g"
pless() (pygmentize -g $@ | less)
zlipd() (printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |cat - $@ |gzip -dc)

export HOME=${HOME%%/}  # remove accidental trailing slash
eval $(dircolors ~/customize/dircolors-solarized/dircolors.ansi-light)

# https://stackoverflow.com/a/7110386/321973
trap 'echo -ne "\033]0;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

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
  eval $(ssh-agent)
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

# https://unix.stackexchange.com/a/113768/863
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  echo "Press CTRL+C now to skip tmux"
  sleep 5
  # https://unix.stackexchange.com/a/176885/863
  exec tmux -2 new-session -A -s main
fi
