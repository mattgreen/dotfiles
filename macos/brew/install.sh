#!/bin/bash

echo "Installing essentials via brew..."
brew bundle --no-lock --file $(dirname "$0")/Brewfile
