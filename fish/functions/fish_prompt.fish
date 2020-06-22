if status is-interactive
  function __prompt_git_branch
    set -l branch (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
    if test -z $branch
      set branch (command git rev-parse --short HEAD 2>/dev/null)
    end

    echo -sn $branch
  end

  function __prompt_git_status
    set -l branch ""
    set -l dirty ""
    set -l uid (ps hotty $fish_pid | tail -n1 | string replace ' ' '')
    set -l prompt_result "__prompt_result_$uid"
    
    if ! set -q __prompt_git_static
      set -g __prompt_git_static (__prompt_git_branch)
      set branch $__prompt_git_static

      set -l cmd "git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l | sed 's/^ *//g'"
      fish -c "set -U $prompt_result ($cmd); kill -WINCH $fish_pid" >/dev/null 2>&1 &
    else
      set branch $__prompt_git_static
      set dirty " "

      if test "$$prompt_result" != "0"
        set dirty "•"
      end

      set -e __prompt_git_static
      set -e $prompt_result
    end

    echo -n " on "
    set_color blue
    echo -n $branch $dirty
    set_color normal
  end

  function fish_prompt
      set -l cwd (pwd | string replace "$HOME" '~')

      echo ''
      set_color green; echo -sn $cwd; set_color normal;

      set -l git_working_tree (command git rev-parse --show-toplevel 2>/dev/null)
      if test -n "$git_working_tree"
          __prompt_git_status
      end
      
      printf '\n❯ '
  end
end