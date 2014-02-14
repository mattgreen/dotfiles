precmd() {
    local tabtitle=$(basename "$PWD")

    echo -ne "\e]1;${tabtitle: -24}\a"
    echo -ne "\e]2;$PWD\a"
}

preexec() {
    echo -ne "\e]1;$2\a"
    echo -ne "\e]2;$PWD\a"
}
