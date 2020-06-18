function __pure_run_async
  set -l job_unique_flag $argv[1]
  if set -q $job_unique_flag
    return 0
  end

  set -l callback_function $argv[2]
  set -l cmd $argv[3]
  set -l async_job_result _async_job_result_(random)
  set -g $job_unique_flag
  set -U $async_job_result "…"

  fish -c "set -U $async_job_result (eval $cmd)" &

  set -l pid (jobs --last --pid)

  # prevent blocking exit while job is running
  disown $pid

  function _async_job_$pid -v $async_job_result -V pid -V async_job_result -V callback_function -V job_unique_flag
    set -e $job_unique_flag
    eval $callback_function $$async_job_result
    functions -e _async_job_$pid
    set -e $async_job_result
  end
end

function __pure_git_info
  if not set -q __pure_git_last_dirty_check
    set -g __pure_git_last_dirty_check 0
  end

  set -l working_tree $argv[1]
  set -l current_timestamp (__pure_timestamp)
  set -l time_since_last_dirty_check (math "$current_timestamp - $__pure_git_last_dirty_check")

  pushd $working_tree
  if test $time_since_last_dirty_check -gt 10
    set -l cmd "command git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l"
    __pure_run_async "__pure_checking_dirty" __pure_git_dirty_callback $cmd
  end

  set -l git_branch_name (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')

  # handle detached HEAD
  if test -z $git_branch_name
    set git_branch_name (command git rev-parse --short HEAD 2>/dev/null)
  end
  popd

  set -l git_dirty_mark
  if set -q __pure_git_is_dirty
    set git_dirty_mark " •"
  end

  echo -sn " on "
  set_color blue; echo -sn $git_branch_name $git_dirty_mark; set_color normal
end

function fish_prompt
    echo ''
    set_color green; echo -sn (dirs); set_color normal;

    set -l git_working_tree (command git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$git_working_tree"
        __pure_git_info $git_working_tree
    end

    echo ''
    echo '❯ '
end
