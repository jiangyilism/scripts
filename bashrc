if [[ ! $- == *i* ]]; then
	return
fi

HISTCONTROL=ignoreboth
HISTSIZE=1024
HISTFILESIZE=2048
shopt -s histappend
shopt -s checkwinsize

cmd_timestamp_file="/tmp/${USER}.${BASHPID}.cmd_timestamp"
cmd_exe_time_file="/tmp/${USER}.${BASHPID}.cmd_exe_time"
trap 'rm -f ${cmd_timestamp_file} ${cmd_exe_time_file}' EXIT

function seconds_to_str() {
	local total_sec=${1:-0}
	local sec=$((total_sec % 60))
	local min=$(((total_sec / 60) % 60))
	local hour=$(((total_sec / 3600) % 60))
	local day=$(((total_sec / 86400)))

	[[ ${day} -gt 0 ]] && printf '%dd' ${day}
	[[ ${hour} -gt 0 ]] && printf '%02dh' ${hour}
	[[ ${min} -gt 0 ]] && printf '%02dm' ${min}
	printf '%02ds' ${sec}
}

function time_elapsed_since() {
	local timestamp0="$(date +'%D %H:%M:%S')"
	local timestamp1="${1}"
	local sec0=$(date -d "${timestamp0}" +%s)
	local sec1=$(date -d "${timestamp1}" +%s)

	echo $(seconds_to_str $((sec0 - sec1)))
}

function start_cmd_timer() {
	date +'%D %H:%M:%S' > ${cmd_timestamp_file}
	rm -f ${cmd_exe_time_file}
}

function prompt_command() {
	local exit_code=$?

	if [[ -f ${cmd_exe_time_file} ]]; then
		cat ${cmd_exe_time_file}
		return
	fi

	local prev_timestamp="$(cut -d' ' -f2 "${cmd_timestamp_file}")"
	local cur_timestamp="$(date +%H:%M:%S)"

	printf "\e[01;$((${exit_code}==0 ? 32 : 31))m\n----[%s - %s | exe time: %s | exit code: %03d]----\e[0m\n" "${prev_timestamp}" "${cur_timestamp}" $(time_elapsed_since "$(< ${cmd_timestamp_file})") ${exit_code} | tee ${cmd_exe_time_file}
}

start_cmd_timer
PROMPT_COMMAND='prompt_command'
PS0='$(start_cmd_timer)'
PS1='\[\e[01;34m\]\u\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '
export PS4='+\e[90m${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}: }\e[0m'

echo -e "\033]0;$(whoami)@$(hostname)\007"

if [[ -x /usr/bin/dircolors ]]; then
	eval "$(dircolors -b)"
	alias ls='ls --color=always'
	alias grep='grep --color=auto --exclude-dir=.git -I'
fi

alias ll='ls -alF'

if [[ -f ~/.bash_aliases ]]; then
	. ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
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

export CXXFLAGS="-O2 -pipe -Wall -Wextra"
export CFLAGS="-O2 -pipe -Wall -Wextra"
export LDFLAGS="-Wl,-O2 -Wl,--as-needed"
