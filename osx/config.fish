# Favor Homebrew binaries over system
set PATH /usr/local/bin /usr/local/sbin $PATH

# Add external brew commands
set PATH $HOME/.dotfiles/osx/brew $PATH

# Prefer coreutils if installed
if test -d /usr/local/opt/coreutils/libexec/gnubin
    set PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
end
