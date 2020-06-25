if status is-interactive
    set -g __prompt_uid (ps hotty $fish_pid | tail -n1 | string replace ' ' '')
    set -g __prompt_cmd_id 0
    set -g __prompt_git_state_cmd_id 0

    function __prompt_preexec --on-event fish_preexec
        set __prompt_cmd_id (math $__prompt_cmd_id + 1)
    end

    function __prompt_cleanup --on-event fish_exit
        set -e "__prompt_result_$__prompt_uid"
    end

    function __prompt_git_status
        if test $__prompt_cmd_id -ne $__prompt_git_state_cmd_id
            set -g __prompt_git_state_cmd_id $__prompt_cmd_id
            set -g __prompt_git_branch ""
            set -g __prompt_dirty ""
        end

        if test -z $__prompt_git_branch
            set -l branch (git symbolic-ref --short HEAD)
            if test -z $branch
                set branch (git rev-parse --short HEAD 2>/dev/null)
            end

            set -g __prompt_git_branch $branch
        end

        if test -z $__prompt_dirty
            set -l prompt_result "__prompt_result_$__prompt_uid"

            if ! set -q __prompt_dirty_state
                set -g __prompt_dirty_state 0
            end

            if test $__prompt_dirty_state -eq 0
                set -g __prompt_dirty_state 1

                set -l cmd "git status -unormal --porcelain --ignore-submodules 2>/dev/null | wc -l | sed 's/^ *//g'"
                fish --private -c "set -U $prompt_result ($cmd); kill -WINCH $fish_pid" >/dev/null 2>&1 &

                # Allow async call a chance to finish so we can appear synchronous
                sleep 0.015
            end

            if set -q $prompt_result
                if test $__prompt_dirty_state -eq 1
                    if test $$prompt_result != "0"
                        set -g __prompt_dirty "•"
                    end

                    set -e $prompt_result
                    set -e __prompt_dirty_state
                end
            end
        end

        set -l dirty $__prompt_dirty
        if test -z $dirty
            set -l dirty "…"
        end

        echo -n $__prompt_git_branch $dirty
    end

    function fish_prompt
        set -l cwd (pwd | string replace "$HOME" '~')

        echo ''
        set_color green; echo -sn $cwd; set_color normal

        set -l git_working_tree (command git rev-parse --show-toplevel 2>/dev/null)
        if test -n "$git_working_tree"
            echo -sn " on "
            set_color blue; __prompt_git_status; set_color normal
        end

        echo -en '\n❯ '
    end
end
