# Use nvim as editor if available
set -gx EDITOR vim
command -q nvim && set -gx EDITOR nvim

# Be intentional about use of color
set fish_color_operator normal

# Homebrew config
set -gx HOMEBREW_NO_EMOJI 1
set -gx HOMEBREW_NO_ANALYTICS 1

# Haskell
fish_add_path --path --append "$HOME/.ghcup/bin"
fish_add_path --path --append "$HOME/.cabal/bin"

# Rust
fish_add_path --path --append "$HOME/.cargo/bin"

# Source machine-local config if it exists
set --local FISH_CONFIG_ROOT (dirname (status --current-filename))
if test -f "$FISH_CONFIG_ROOT/config.local.fish"
    source "$FISH_CONFIG_ROOT/config.local.fish"
end

