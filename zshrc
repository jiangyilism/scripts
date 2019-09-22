#setopt sharehistory      #Share history across terminals
setopt appendhistory     #Append history to the history file (no overwriting)
setopt auto_param_slash
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt mark_dirs
setopt sh_word_split
unsetopt auto_menu
unsetopt menu_complete

HISTDUP=erase                    #Erase duplicates in the history file
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=1024                    #How many lines of history to keep in memory
SAVEHIST=2048                    #Number of history entries to save to disk

. "${HOME}/.shrc_common"

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

PS1='%B%F{blue}%n%f:%F{blue}%d%f$ %b'

function preexec() {
	local -r cmd="${1}"

	print -Pn "\e]2;${cmd}\a"
	start_cmd_timer
}

function precmd() {
	prompt_command
}

start_cmd_timer
