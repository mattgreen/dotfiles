function j
    if count $argv > /dev/null
        cd ~/Projects/$argv[1]
    else
        cd ~/Projects
    end
end
