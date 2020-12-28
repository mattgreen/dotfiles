# Use nvim as editor if available
set -gx EDITOR vim
command -q nvim && set -gx EDITOR nvim

# Homebrew config
set -gx HOMEBREW_NO_EMOJI 1
set -gx HOMEBREW_NO_ANALYTICS 1

# Rust
if test -d "$HOME/.cargo"
    set --export PATH "$HOME/.cargo/bin" $PATH
end