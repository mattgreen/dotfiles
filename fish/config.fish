# Use nvim as editor if available
set -gx EDITOR vim
command -q nvim && set -gx EDITOR nvim

# Set theme
set --global fish_color_autosuggestion brblack
set --global fish_color_cancel
set --global fish_color_command
set --global fish_color_comment brblack
set --global fish_color_cwd normal
set --global fish_color_cwd_root normal
set --global fish_color_end
set --global fish_color_error brred
set --global fish_color_escape
set --global fish_color_history_current
set --global fish_color_host normal
set --global fish_color_host_remote yellow
set --global fish_color_keyword
set --global fish_color_normal normal
set --global fish_color_operator
set --global fish_color_option
set --global fish_color_param
set --global fish_color_quote green
set --global fish_color_redirection
set --global fish_color_search_match --reverse
set --global fish_color_selection --reverse
set --global fish_color_status normal
set --global fish_color_user normal
set --global fish_color_valid_path
set --global fish_pager_color_background
set --global fish_pager_color_completion normal
set --global fish_pager_color_description brblack
set --global fish_pager_color_prefix --underline=single
set --global fish_pager_color_progress brblack
set --global fish_pager_color_secondary_background
set --global fish_pager_color_secondary_completion
set --global fish_pager_color_secondary_description
set --global fish_pager_color_secondary_prefix
set --global fish_pager_color_selected_background --reverse
set --global fish_pager_color_selected_completion
set --global fish_pager_color_selected_description
set --global fish_pager_color_selected_prefix

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

