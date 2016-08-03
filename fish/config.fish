switch (uname -a)
    case "*Darwin*"
        source ../osx/config.fish
    case "*"
        echo 'unknown platform'
end
