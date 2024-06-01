#!/usr/bin/env bash

dir=/tmp/screenshots
file="$(date +"%Y%m%d_%H%M%S").png"

mkdir -p "$dir"
maim -s --hidecursor  | tee "$dir/$file" | xclip -selection clipboard -t image/png
notify-send "Screenshot saved to clipboard and to $dir/$file" 
