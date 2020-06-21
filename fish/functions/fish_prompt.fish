if status is-interactive
  # set --universal __prompt_git_dirty_$fish_pid 0
  # set --global __prompt_git_checking 0

  # set --global prompt_dirty 0
  # set --global __prompt_git_check 0

  # function __prompt_git_dirty_cleanup --on-process-exit $fish_pid
  #   set --erase __prompt_git_dirty_$fish_pid
  # end

  # function __prompt_git_dirty_check_done --on-variable __prompt_git_dirty_$fish_pid
  #   set --global __prompt_git_checking 0
  # end

  # function __prompt_git_info
  #   set -l git_branch_name (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')

  #   # handle detached HEAD
  #   if test -z $git_branch_name
  #     set git_branch_name (command git rev-parse --short HEAD 2>/dev/null)
  #   end

  #   echo -sn " on "
  #   set_color blue; echo -sn $git_branch_name; set_color normal

  #   __prompt_git_dirty
  #   # if test "$__prompt_git_checking" -eq 0
  #   #   set --global __prompt_git_checking 1

  #   #   set --local dirty_cmd "git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l | sed 's/^ *//g'"
  #   #   set --local cmd "set --universal __prompt_git_dirty_$fish_pid ($dirty_cmd)"
  #   #   async_run "prompt_dirty_check" __prompt_git_dirty_check_done $cmd
  #   #   # async_run "__prompt_dirty_check_$fish_pid" "kill -WINCH $fish_pid" $cmd
  #   # end

    
  # end

  function __prompt_git_branch
    set -l branch (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
    if test -z $branch
      set branch (command git rev-parse --short HEAD 2>/dev/null)
    end

    set_color blue; echo -sn $branch; set_color normal
  end

  function __prompt_git_dirty
    set -u prompt_result ""

    # function __prompt_git_dirty_done_$pid --on-variable __prompt_result_$uid -V uid
    #   # set -g __prompt_git_num_dirty $prompt_result
    #   # set -g __prompt_git_num_dirty (echo __prompt_result_$uid

    #   functions -e __prompt_git_dirty_done_$pid
    # end

    set -l cmd "git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l | sed 's/^ *//g'"
    fish -c "set -U prompt_result ($cmd); kill -WINCH $fish_pid" >/dev/null 2>&1 &
  end

  function __prompt_git_status
    set -l dirty ""
    set -l done 0

    if ! set -q __prompt_git_static
      set -g __prompt_git_static (__prompt_git_branch)
      __prompt_git_dirty
    else
      set dirty $prompt_result
      set -e prompt_result
      set done 1
    end

    printf " on %s %s" $__prompt_git_static $dirty

    if test "$done" -eq 1
       set -e __prompt_git_static
    end
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