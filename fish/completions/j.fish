function __fish_j_completion
    set --local comp (commandline -ct)
    set -l j_root (string trim --right --chars / $j_path)
    __fish_complete_directories "$j_root/$comp" "" | string replace "$j_root/" ""
end

complete --exclusive --command j --arguments '(__fish_j_completion)'
