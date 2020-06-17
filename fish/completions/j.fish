function __fish_j_completion
    set --local comp (commandline -ct)
    __fish_complete_directories "~/Projects/$comp" "" | string replace "~/Projects/" ""
end

complete --exclusive --command j --arguments '(__fish_j_completion)'
