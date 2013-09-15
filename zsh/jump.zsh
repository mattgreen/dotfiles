function jump() {
    cd ~/Projects/$1
}

function _jump() {
    _directories -W ~/Projects
}

alias j='jump'
compdef _jump jump
