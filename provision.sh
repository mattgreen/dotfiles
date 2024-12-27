#!/bin/sh

touch ~/.hushlogin

ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/gitignore ~/.gitignore

mkdir -p ~/.config
ln -sfn ~/.dotfiles/fish ~/.config/fish
ln -sfn ~/.dotfiles/macos/ghostty ~/.config/ghostty

mkdir -p ~/.ssh
ln -sf ~/.dotfiles/ssh/config ~/.ssh/config

