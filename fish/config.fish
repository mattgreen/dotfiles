# Use nvim as editor if available
set -gx EDITOR vim
command -q nvim && set -gx EDITOR nvim

# Homebrew config
fish_add_path --path --prepend "/opt/homebrew/bin"
set -gx HOMEBREW_NO_EMOJI 1
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400

# .NET
fish_add_path --path --append "$HOME/.dotnet/tools"
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx DOTNET_WATCH_RESTART_ON_RUDE_EDIT 1
set -gx DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER 1

# Godot
fish_add_path --path --append "$HOME/Library/Application Support/godotenv/godot/bin"
set -gx GODOT "$HOME/Library/Application Support/godotenv/godot/bin/godot"

# Rust
fish_add_path --path --append "$HOME/.cargo/bin"

# Source machine-local config if it exists
set --local FISH_CONFIG_ROOT (dirname (status --current-filename))
if test -f "$FISH_CONFIG_ROOT/config.local.fish"
    source "$FISH_CONFIG_ROOT/config.local.fish"
end

