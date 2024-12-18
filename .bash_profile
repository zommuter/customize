#set -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# source the users bashrc if it exists
#if [ -f "${HOME}/.bashrc" ] ; then
#  source "${HOME}/.bashrc"
#fi

# Set PATH so it includes user's private bin if it exists
 if [ -d "${HOME}/bin" ] ; then
   PATH="${HOME}/bin:${PATH}"
 fi

# Set MANPATH so it includes users' private man if it exists
 if [ -d "${HOME}/man" ]; then
   MANPATH="${HOME}/man:${MANPATH}"
 fi

# Set INFOPATH so it includes users' private info if it exists
 if [ -d "${HOME}/info" ]; then
   INFOPATH="${HOME}/info:${INFOPATH}"
 fi

source "${HOME}/customize/colorprompt.sh"
source "${HOME}/customize/historyprompt.sh"
source "${HOME}/customize/aliases.sh"

DISPLAY=:0.0

#LANG=C
#LC_ALL=$LANG
#LC_CTYPE=C

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
		#export DISPLAY="$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0"
		#export LIBGL_ALWAYS_INDIRECT=1
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

export HOME=${HOME%%/}  # remove accidental trailing slash
eval $(dircolors ~/customize/dircolors-solarized/dircolors.ansi-light)

# https://stackoverflow.com/a/7110386/321973
#trap 'echo -ne "\033]0;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

# https://unix.stackexchange.com/a/113768/863
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  echo "Press CTRL+C now to skip tmux"
  sleep 5
  # https://unix.stackexchange.com/a/176885/863
  exec tmux -2 new-session -A -s main
fi
