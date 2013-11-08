#!/bin/bash
#
# Integrates a better MacVim logo
#
target=$(find /usr/local/Cellar -name MacVim.app 2> /dev/null | sort | tail -n 1)
path="$target/Contents/Resources/"

wget -O /tmp/MacVim.icns http://dribbble.com/shots/337065-MacVim-Icon-Updated/attachments/15582

cp /tmp/MacVim.icns $path

echo
echo
echo "Please restart MacVim to see the new icon"

