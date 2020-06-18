function __prompt_git_info
  set -l git_branch_name (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')

  # handle detached HEAD
  if test -z $git_branch_name
    set git_branch_name (command git rev-parse --short HEAD 2>/dev/null)
  end

  echo -sn " on "
  set_color blue; echo -sn $git_branch_name; set_color normal
end

function fish_prompt
    echo ''
    set_color green; echo -sn (dirs); set_color normal;

    set -l git_working_tree (command git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$git_working_tree"
        __prompt_git_info
    end

    echo ''
    echo '❯ '
end
