if [[ ! $- == *i* ]]; then
	return
fi

HISTCONTROL=ignoreboth
HISTSIZE=1024
HISTFILESIZE=2048
shopt -s histappend
shopt -s checkwinsize

if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}$(tmp=$?; printf "\[\e[01;$(($tmp==0 ? 32 : 31))m\][%03d]\[\e[0m\]" $tmp)\[\e[01;34m\]\u\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '

echo -e "\033]0;$(whoami)@$(hostname)\007"

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=always'
	alias grep='grep --color=auto --exclude-dir=.git -I'
fi

alias ll='ls -alF'

if [[ -f ~/.bash_aliases ]]; then
	. ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

tabs -2

if [[ -f /usr/bin/clang ]]; then
	export CXX=/usr/bin/clang++
	export CC=/usr/bin/clang
	export AR=/usr/bin/llvm-ar
	export RANLIB=/usr/bin/llvm-ranlib
elif [[ -f /usr/bin/gcc ]]; then
	export CXX=/usr/bin/g++
	export CC=/usr/bin/gcc
	export AR=/usr/bin/ar
	export RANLIB=/usr/bin/ranlib
fi

COMMON_FLAGS="-O2 -pipe -Wall"
export CXXFLAGS="${COMMON_FLAGS} -std=gnu++17"
export CFLAGS="${COMMON_FLAGS} -std=gnu11"
unset COMMON_FLAGS
