#!/usr/bin/env bash

dir=~/Screenshots
file="$(date +"%Y%m%d_%H%M%S").png"

mkdir -p "$dir"
maim -s "$dir/$file"
notify-send "Screenshot saved to $dir/$file" 
