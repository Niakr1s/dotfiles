#!/bin/bash

WALLPAPER="$HOME/.wallpaper"

curl -fLo "$WALLPAPER" "$1"

echo "$1" > "$WALLPAPER.url"

cat > "$HOME/.config/hypr/hyprpaper.conf" << EOF
wallpaper {
  monitor =
  fit_mode = cover
  path = $WALLPAPER
}
EOF

hyprctl hyprpaper wallpaper ",$WALLPAPER,"
