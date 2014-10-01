autoload -U colors && colors

prompt_git_info() {
    local repo_path=`git rev-parse --git-dir 2>/dev/null`
    if [[ $repo_path != '' && $repo_path != '~' && $repo_path != "$HOME/.git" ]]; then
        local branch=`git symbolic-ref --short HEAD`

        local mode=""
        if [[ -e "$repo_path/BISECT_LOG" ]]; then
          mode="+bisect"
        elif [[ -e "$repo_path/MERGE_HEAD" ]]; then
          mode="+merge"
        elif [[ -e "$repo_path/rebase" || -e "$repo_path/rebase-apply" || -e "$repo_path/rebase-merge" || -e "$repo_path/../.dotest" ]]; then
          mode="+rebase"
        fi

        local dirty_icon=""
        if [ -n "$(git status -s --ignore-submodules=dirty)" ]; then
            dirty_icon=" %{$fg[cyan]%}•%{$reset_color%}"
        fi

        local branch_color="$fg[cyan]"
        print -P " on %{$branch_color%}$branch$mode$dirty_icon%{$reset_color%}"
    fi
}

setopt PROMPT_SUBST

PROMPT='
%{$fg[green]%}%d%{$reset_color%}$(prompt_git_info)
❯ '
