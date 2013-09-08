# History config
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000

setopt APPEND_HISTORY
#setopt INC_APPEND_HISTORY SHARE_HISTORY # share history across sessions
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS # Drop extraneous whitespace

# Terminal config
export CLICOLOR=1
export TERM=xterm-256color
