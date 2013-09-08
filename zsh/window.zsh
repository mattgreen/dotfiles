precmd() {
    local currentpath=${PWD/${HOME}/\~}

    echo -ne "\e]1;${currentpath: -24}\a"  # Tab title (max 24 chars)
    echo -ne "\e]2;${currentpath}\a"       # Window title
}

preexec() {
    local currentpath=${PWD/${HOME}/\~}

    echo -ne "\e]1;$2\a"
    echo -ne "\e]2;${currentpath}\a"
}
