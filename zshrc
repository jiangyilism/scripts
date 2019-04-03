setopt SH_WORD_SPLIT
setopt appendhistory     #Append history to the history file (no overwriting)
#setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed

HISTSIZE=1024            #How many lines of history to keep in memory
HISTFILE=~/.zsh_history  #Where to save history to disk
SAVEHIST=2048            #Number of history entries to save to disk
HISTDUP=erase            #Erase duplicates in the history file

. ~/.shrc_common

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

PS1='%B%F{blue}%n%f:%F{blue}%d%f$ %b'

function preexec() {
	local cmd=${1}

	print -Pn "\e]2;${cmd}\a"
	start_cmd_timer
}

function precmd() {
  prompt_command
}

start_cmd_timer
