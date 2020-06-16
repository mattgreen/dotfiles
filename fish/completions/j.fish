function __fish_complete_projects
    ls -F ~/Projects
end


complete --exclusive --command j --arguments '(__fish_complete_projects)'