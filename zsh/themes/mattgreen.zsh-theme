local return_code="%(?. .%{$fg[red]%}↵%{$reset_color%})"
local git_info='$(~/.config/zsh/bin/git-cwd-info)'

PROMPT="%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg[green]%}%~%{$reset_color%} $ "
RPROMPT="${git_info} ${return_code}"
