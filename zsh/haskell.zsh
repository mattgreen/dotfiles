if [[ -d ~/.cabal/bin ]]; then
    path=(~/.cabal/bin $path)
fi

if [[ -d ~/.local/bin ]]; then
    path=(~/.local/bin $path)
fi
