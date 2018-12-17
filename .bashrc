if [[ ! $- == *i* ]]; then
	return
fi

HISTCONTROL=ignoreboth
HISTSIZE=1024
HISTFILESIZE=2048
shopt -s histappend
shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}\[\e[01;34m\]\u\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\\$ '

function print_exit_code {
	tmp=$?
	printf "\e[01;$(($tmp==0 ? 32 : 31))m[%03d]\e[0m" ${tmp}
	return ${tmp}
}

export PROMPT_COMMAND="print_exit_code"

echo -e "\033]0;$(hostname)\007"

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=always'
	alias grep='grep --color=always --exclude-dir=.git -I'
fi

# some more ls aliases
alias ll='ls -alF'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

tabs 2
