set --local plugins (find "$__fish_config_dir/plugins" -type d -not -path plugins -depth 1)

for plugin in $plugins
    if test -d "$plugin/completions"; and not contains "$plugin/completions" $fish_complete_path
        set fish_complete_path "$plugin/completions" $fish_complete_path
    end
    if test -d "$plugin/functions"; and not contains "$plugin/functions" $fish_function_path
        set fish_function_path "$plugin/functions" $fish_function_path
    end
    for f in "$plugin/conf.d"/*.fish
        builtin source "$f"
    end
end

set --erase plugins