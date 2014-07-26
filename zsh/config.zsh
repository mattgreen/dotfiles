# History config
HISTFILE=~/.zsh_history
HISTSIZE=4000
SAVEHIST=4000

setopt APPEND_HISTORY
#setopt INC_APPEND_HISTORY SHARE_HISTORY # share history across sessions
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS # Drop extraneous whitespace

# Terminal config
export CLICOLOR=1
export EDITOR="mvim -f"
export TERM=xterm-256color
