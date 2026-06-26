function code
    if test "$(uname)" = 'Darwin'
        env VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $argv
    else
        env VSCODE_CWD="$PWD" code $argv
    end
end
