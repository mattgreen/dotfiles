# Default appearance options.
# Override in config.fish if you want.
if ! set -q __prompt_dirty_indicator
    set -g __prompt_dirty_indicator "•"
end

# This should be set to be at least as long as __prompt_dirty_indicator, due to a fish bug
if ! set -q __prompt_clean_indicator
    set -g __prompt_clean_indicator (string replace -r -a '.' ' ' $__prompt_dirty_indicator)
end

if ! set -q __prompt_cwd_color
    set -g __prompt_cwd_color green
end

if ! set -q __prompt_git_color
    set -g __prompt_git_color blue
end


# State used for memoization and async calls.
set -g __prompt_cmd_id 0
set -g __prompt_git_state_cmd_id -1
set -g __prompt_git_static ""
set -g __prompt_dirty ""

# Increment a counter each time a prompt is about to be displayed.
# Enables us to distingish between redraw requests and new prompts.
function __prompt_increment_cmd_id --on-event fish_prompt
    set __prompt_cmd_id (math $__prompt_cmd_id + 1)
end

# Abort an in-flight dirty check, if any.
function __prompt_abort_check
    if set -q __prompt_check_pid
        set -l pid $__prompt_check_pid
        functions -e __prompt_on_finish_$pid
        command kill $pid >/dev/null 2>&1
        set -e __prompt_check_pid
    end
end

function __prompt_git_status
    # Reset state if this call is *not* due to a redraw request
    set -l prev_dirty $__prompt_dirty
    if test $__prompt_cmd_id -ne $__prompt_git_state_cmd_id
        __prompt_abort_check

        set __prompt_git_state_cmd_id $__prompt_cmd_id
        set __prompt_git_static ""
        set __prompt_dirty ""
    end

    # Determine git working directory
    set -l git_dir (command git rev-parse --absolute-git-dir 2>/dev/null)
    if test $status -ne 0
        return 1
    end

    # Fetch git position & action synchronously.
    # Memoize results to avoid recomputation on subsequent redraws.
    if test -z $__prompt_git_static
        set -l position (command git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
        if test $status -ne 0
            # Denote detached HEAD state with short commit hash
            set position (command git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
            if test $status -eq 0
                set position "@$position"
            end
        end

        # TODO: add bisect
        set -l action ""
        if test -f "$git_dir/MERGE_HEAD"
            set action "merge"
        else if test -d "$git_dir/rebase-merge"
            set branch "rebase"
        else if test -d "$git_dir/rebase-apply"
            set branch "rebase"
        end

        set -l state $position
        if test -n $action
            set state "$state <$action>"
        end

        set -g __prompt_git_static $state
    end

    # Fetch dirty status asynchronously.
    if test -z $__prompt_dirty
        if ! set -q __prompt_check_pid
            # Compose shell command to run in background
            set -l check_cmd "git --no-optional-locks status -unormal --porcelain --ignore-submodules 2>/dev/null | head -n1 | count"
            set -l cmd "if test ($check_cmd) != "0"; exit 1; else; exit 0; end"

            begin
                # Defer execution of event handlers by fish for the remainder of lexical scope.
                # This is to prevent a race between the child process exiting before we can get set up.
                block -l

                set -g __prompt_check_pid 0
                command fish --private --command "$cmd" >/dev/null 2>&1 &
                set -l pid (jobs --last --pid)

                set -g __prompt_check_pid $pid

                # Use exit code to convey dirty status to parent process.
                function __prompt_on_finish_$pid --inherit-variable pid --on-process-exit $pid
                    functions -e __prompt_on_finish_$pid

                    if set -q __prompt_check_pid
                        if test $pid -eq $__prompt_check_pid
                            switch $argv[3]
                                case 0
                                    set -g __prompt_dirty_state 0
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                                case 1
                                    set -g __prompt_dirty_state 1
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                                case '*'
                                    set -g __prompt_dirty_state 2
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                            end
                        end
                    end
                end
            end
        end

        if set -q __prompt_dirty_state
            switch $__prompt_dirty_state
                case 0
                    set -g __prompt_dirty $__prompt_clean_indicator
                case 1
                    set -g __prompt_dirty $__prompt_dirty_indicator
                case 2
                    set -g __prompt_dirty "<err>"
            end

            set -e __prompt_check_pid
            set -e __prompt_dirty_state
        end
    end

    # Render git status. When in-progress, use previous state to reduce flicker.
    set_color $__prompt_git_color
    echo -n $__prompt_git_static ''

    if ! test -z $__prompt_dirty
        echo -n $__prompt_dirty
    else if ! test -z $prev_dirty
        set_color --dim $__prompt_git_color
        echo -n $prev_dirty
        set_color normal
    end

    set_color normal
end

function fish_prompt
    set -l cwd (pwd | string replace "$HOME" '~')

    echo ''
    set_color $__prompt_cwd_color
    echo -sn $cwd
    set_color normal

    if test $cwd != '~'
        set -l git_state (__prompt_git_status)
        if test $status -eq 0
            echo -sn " on $git_state"
        end
    end

    echo -en '\n❯ '
end
