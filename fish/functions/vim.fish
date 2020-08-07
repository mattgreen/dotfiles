function vim
    # Use nvim if installed, and vim otherwise.
    if command -sq nvim
        command nvim $argv
    else
        command vim $argv
    end
end
