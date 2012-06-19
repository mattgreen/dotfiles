local return_code="%(?. .%{$fg[red]%}↵%{$reset_color%})"
local git_info='$(~/.config/zsh/bin/git-cwd-info)'
local user_info="%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}"
local cwd_info="%{$fg[green]%}%~%{$reset_color%}"

PROMPT="${cwd_info} $ "
RPROMPT="${git_info}"
