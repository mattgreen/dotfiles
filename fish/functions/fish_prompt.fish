if status is-interactive
  function __prompt_git_branch
    set -l branch (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
    if test -z $branch
      set branch (command git rev-parse --short HEAD 2>/dev/null)
    end

    set_color blue; echo -sn $branch; set_color normal
  end

  function __prompt_git_status
    set -l branch ""
    set -l dirty ""
    set -l uid $fish_pid # TODO use tty ID
    set -l prompt_result "__prompt_result_$uid"
    
    if ! set -q __prompt_git_static
      set -g __prompt_git_static (__prompt_git_branch)
      set branch $__prompt_git_static

      set -U $result ""
      set -l cmd "git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l | sed 's/^ *//g'"
      fish -c "set -U $prompt_result ($cmd); kill -WINCH $fish_pid" >/dev/null 2>&1 &
    else
      set branch $__prompt_git_static
      set dirty " "
      if test "$$prompt_result" != "0"
        set dirty "*"
      end

      set -e __prompt_git_static
      set -e $prompt_result
    end

    printf " on %s %s" $branch $dirty
  end

  # function __prompt_git_dirty
  #   if set --query __prompt_dirty_checking_$fish_pid
  #     return 0
  #   end

  #   set --local uid (random)
  #   set --local cmd "sleep 1; git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l | sed 's/^ *//g'"
  #   set --universal __prompt_result_$uid ""

  #   function on_prompt_finish_$uid --on-variable __prompt_result_$uid -V uid
  #     set fish_bind_mode "insert"
  #     set fish_bind_mode "default"
  #     functions -e on_prompt_finish_$uid
  #   end

  #   fish -c "sleep 1; set -U __prompt_result_$uid (1); kill -WINCH $fish_pid" >/dev/null 2>&1 &

  #   # async_run "__prompt_dirty_checking_$fish_pid" __prompt_git_dirty_finish $cmd



  #   if set --query __prompt_result_$uid
  #     if test "$__prompt_result_$uid" -eq 0
  #       echo -sn "  "
  #     else
  #       echo -sn " d"
  #     end

  #     set --erase "__prompt_result_$uid"
  #     set -U "__prompt_dirty_checking_$fish_pid"
  #   end
  # end

  function fish_prompt
      echo ''
      set_color green; echo -sn (dirs); set_color normal;

      set -l git_working_tree (command git rev-parse --show-toplevel 2>/dev/null)
      if test -n "$git_working_tree"
          __prompt_git_status
      end
      
      echo ''
      echo '❯ '
  end
end