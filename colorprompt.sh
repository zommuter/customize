#!/bin/bash

CL_D="\[\e[m\]"
CL_R="\[\e[0;31m\]"
CL_G="\[\e[0;32m\]"
CL_B="\[\e[0;34m\]"
#CL_W="\[\e[1;37m\]"
ON_R="\[\e[41m\]"
PROMPT_COMMAND="ERL=\$?;$PROMPT_COMMAND"

ERR="\$([[ \$ERL != 0 ]] && echo \${ON_R})\$(printf '%3i' \$ERL)${CL_D}"
#USR="${CL_G}\\u${CL_D}"
#HST="${CL_R}\\h${CL_D}"
#WRK="${CL_B}\\w${CL_D}"

hash2rgb()
{
  HASH=$(echo $1 | sha1sum)
  C=$((16#${HASH:0:2}/2))
  M=$((16#${HASH:2:2}/2))
  Y=$((16#${HASH:4:2}))
  R=$((256-$C/2))
  G=$((256-$M))
  B=$((256-$Y/2))
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
#PS1="\[\e]0;\${ERL} \u@\h: \w\007\]${PS1}"

PS1_TEMPLATE="$PS1"
PROMPT_COMMAND="$PROMPT_COMMAND;PS1=\"$(echo ${PS1_TEMPLATE})\""

#http://stackoverflow.com/a/16178979
color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

err()(echo $@ >&2)

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