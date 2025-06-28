#!/usr/bin/env bash
set -euo pipefail

# allow globs that find nothing to disappear
shopt -s nullglob

# build a list of both .png and .jpg wallpapers
wallpapers=( "$HOME/.config/backgrounds/berserk-"*.png \
             "$HOME/.config/backgrounds/berserk-"*.jpg )

if (( ${#wallpapers[@]} == 0 )); then
  echo "❌ No berserk-*.png or berserk-*.jpg found in $HOME/.config/backgrounds" >&2
  exit 1
fi

# pick one at random
idx=$(( RANDOM % ${#wallpapers[@]} ))
random_wallpaper="${wallpapers[$idx]}"
echo "✅ Chosen wallpaper: $random_wallpaper"

# write the config for all monitors
cfg="$HOME/.config/hypr/hyprpaper.conf"
mkdir -p "${cfg%/*}"
cat > "$cfg" <<EOF
preload = $random_wallpaper
wallpaper = , $random_wallpaper
EOF

# restart hyprpaper so it reloads
pkill hyprpaper 2>/dev/null || true
hyprpaper --config "$cfg" &
