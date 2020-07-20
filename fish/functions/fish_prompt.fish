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
    if test $__prompt_cmd_id -ne $__prompt_git_state_cmd_id
        __prompt_abort_check

        set __prompt_git_state_cmd_id $__prompt_cmd_id
        set __prompt_git_branch ""
        set __prompt_dirty ""
    end

    if test -z $__prompt_git_branch
        set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
        if test $status -ne 0
            return 1
        end

        if test -z $branch
            set branch (command git rev-parse --short HEAD 2>/dev/null)
        end

        set -g __prompt_git_branch $branch
    end

    if test -z $__prompt_dirty
        if ! set -q __prompt_check_pid
            set -l check_cmd "git status -unormal --porcelain --ignore-submodules 2>/dev/null | head -n1 | count"
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
                                        __fish_repaint
                                    end
                                case 1
                                    set -g __prompt_dirty_state 1
                                    if status is-interactive
                                        __fish_repaint
                                    end
                            end
                        end
                    end
                end
            end

            # Allow async call a chance to finish so we can appear synchronous
            sleep 0.015
        end

        if set -q __prompt_dirty_state
            if test $__prompt_dirty_state -eq 1
                set -g __prompt_dirty "•"
            else
                set -g __prompt_dirty ""
            end

            set -e __prompt_check_pid
            set -e __prompt_dirty_state
        end
    end

    echo -n $__prompt_git_branch $__prompt_dirty
end

function fish_prompt
    set -l cwd (pwd | string replace "$HOME" '~')

    echo ''
    set_color green; echo -sn $cwd; set_color normal

    if test $cwd != '~'
        set -l git_state (__prompt_git_status)
        if test $status -eq 0
            echo -sn " on "
            set_color blue;
            echo -sn $git_state
            set_color normal
        end
    end

    echo -en '\n❯ '
end
