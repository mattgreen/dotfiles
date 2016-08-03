function j --argument-names 'project'
    if test -n "$project"
        cd ~/Projects/$project
    else
        cd ~/Projects
    end
end
