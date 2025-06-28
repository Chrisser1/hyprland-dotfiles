#!/usr/bin/env bash
set -euo pipefail

# allow globs that find nothing to disappear
shopt -s nullglob

# where your wallpapers live
dir="$HOME/.config/backgrounds"

# collect all images by extension
# you can add/remove extensions as you like
exts=(png jpg jpeg webp gif)
wallpapers=()
for e in "${exts[@]}"; do
  for img in "$dir"/*."$e"; do
    [[ -f "$img" ]] && wallpapers+=("$img")
  done
done

if (( ${#wallpapers[@]} == 0 )); then
  echo "❌ No images found in $HOME/.config/backgrounds" >&2
  exit 1
fi

# pick one at random
random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
echo "✅ Chosen wallpaper: $random_wallpaper"

# write the config for all monitors
cfg="$HOME/.config/hypr/hyprpaper.conf"
mkdir -p "${cfg%/*}"
cat > "$cfg" <<EOF
preload = $random_wallpaper
wallpaper = , $random_wallpaper
EOF

# 5) restart hyprpaper so it reloads
pkill hyprpaper 2>/dev/null || true
hyprpaper --config "$cfg" &
