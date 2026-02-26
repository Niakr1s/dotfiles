#!/bin/bash

WALLPAPER="$HOME/.wallpaper"

curl -fLo "$WALLPAPER" "$1"

cat > "$HOME/.config/hypr/hyprpaper.conf" << EOF
wallpaper {
  monitor =
  fit_mode = cover
  path = $WALLPAPER
}
EOF

killall -SIGUSR2 hyprpaper
