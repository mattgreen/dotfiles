function j
    set -l j_root (string trim --right --chars / $j_path)
    if count $argv > /dev/null
        cd $j_root/$argv[1]
    else
        cd $j_root
    end
end
