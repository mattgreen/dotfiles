# Color completions properly
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
