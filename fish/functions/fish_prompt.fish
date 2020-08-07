set -g __prompt_cmd_id 0
set -g __prompt_git_state_cmd_id -1
set -g __prompt_git_branch ""
set -g __prompt_dirty ""

function __prompt_increment_cmd_id --on-event fish_prompt
    set -g __prompt_cmd_id (math $__prompt_cmd_id + 1)
end

function __prompt_abort_check
    if set -q __prompt_check_pid
        set -l pid $__prompt_check_pid
        functions -e __prompt_on_finish_$pid
        command kill $pid >/dev/null 2>&1
        set -e __prompt_check_pid
    end
end

function __prompt_git_status
    set -l prev_dirty $__prompt_dirty
    if test $__prompt_cmd_id -ne $__prompt_git_state_cmd_id
        __prompt_abort_check

        set __prompt_git_state_cmd_id $__prompt_cmd_id
        set __prompt_git_branch ""
        set __prompt_dirty ""
    end

    if test -z $__prompt_git_branch
        set -l branch (command git --no-optional-locks symbolic-ref --short HEAD 2>&1)
        if test $status -ne 0
            if string match 'fatal: not a git repository*' $branch
                return 1
            end

            set branch (command git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
            if test $status -eq 0
                set branch "@$branch"
            end
        end

        set -g __prompt_git_branch $branch
    end

    if test -z $__prompt_dirty
        if ! set -q __prompt_check_pid
            set -l check_cmd "git --no-optional-locks status -unormal --porcelain --ignore-submodules 2>/dev/null | head -n1 | count"
            set -l cmd "if test ($check_cmd) != "0"; exit 1; else; exit 0; end"

            begin
                block -l

                set -g __prompt_check_pid 0
                command fish --private --command "$cmd" >/dev/null 2>&1 &
                set -l pid (jobs --last --pid)

                set -g __prompt_check_pid $pid

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
                    set -g __prompt_dirty " "
                case 1
                    set -g __prompt_dirty "•"
                case 2
                    set -g __prompt_dirty "<err>"
            end

            set -e __prompt_check_pid
            set -e __prompt_dirty_state
        else

        end
    end

    set_color blue
    echo -n $__prompt_git_branch ''
    if ! test -z $__prompt_dirty
        echo -n $__prompt_dirty
    else if ! test -z $prev_dirty
        set_color --dim blue
        echo -n $prev_dirty
        set_color normal
    end
    set_color normal

end

function fish_prompt
    set -l cwd (pwd | string replace "$HOME" '~')

    echo ''
    set_color green
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
