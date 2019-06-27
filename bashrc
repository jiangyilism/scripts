if [[ ! $- == *i* ]]; then
	return
fi

shopt -s histappend
shopt -s checkwinsize

HISTCONTROL=ignoreboth
HISTSIZE=1024
HISTFILESIZE=2048

. "${HOME}/.shrc_common"

start_cmd_timer

PROMPT_COMMAND='prompt_command'
PS0='$(start_cmd_timer)'
PS1='\[\e[01;34m\]\u\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '
export PS4='+\e[90m${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}: }\e[0m'

if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi
