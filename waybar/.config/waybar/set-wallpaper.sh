#!/usr/bin/env bash
set -euo pipefail

wall="$1"                     # absolute path that was chosen
cfg="$HOME/.config/hypr/hyprpaper.conf"

mkdir -p "${cfg%/*}"
cat > "$cfg" <<EOF
preload = $wall
wallpaper = , $wall
EOF

# Restart Hyprpaper so the change is visible right away
pkill -x hyprpaper 2>/dev/null || true
hyprpaper --config "$cfg" &

