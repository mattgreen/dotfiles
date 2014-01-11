#!/bin/bash
#
# Integrates a better MacVim logo
#

target="/Applications/MacVim.app"

if [ ! -d "$target" ]; then
    target=$(find /usr/local/Cellar -name MacVim.app 2> /dev/null | sort | tail -n 1)
fi

if [ "$target" == "" ]; then
    echo "ERROR: can't find MacVim installation (checked /Applications, /usr/local/Cellar)"
    exit 1
fi

path="$target/Contents/Resources/"

wget -O /tmp/MacVim.icns http://dribbble.com/shots/337065-MacVim-Icon-Updated/attachments/15582

echo "Replacing icon at $path..."
cp /tmp/MacVim.icns $path

echo
echo
echo "Please restart to see the new icon"

