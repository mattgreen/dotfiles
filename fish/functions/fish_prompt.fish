function fish_prompt
    set_color green
    printf "\n%s" (pwd)
    set_color normal

    if __git_is_repo
        printf " on "

        set_color cyan
        printf "%s" (__git_branch_name)

        if __git_is_touched
            printf " •"
        end

        set_color normal
    end

    printf "\n❯ "
end

# From OMF
function __git_branch_name -d "Get current branch name"
  __git_is_repo; and begin
    command git symbolic-ref --short HEAD
  end
end

function __git_is_repo -d "Check if directory is a repository"
  test -d .git; or command git rev-parse --git-dir >/dev/null ^/dev/null
end

function __git_is_touched -d "Check if repo has any changes"
  __git_is_repo; and begin
    test -n (echo (command git status --porcelain))
  end
end
