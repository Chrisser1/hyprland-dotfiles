#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

dir="$HOME/.config/backgrounds"
mapfile -t wp_list < <(printf '%s\n' "$dir"/berserk-*.{png,jpg})

(( ${#wp_list[@]} == 0 )) && {
  notify-send "Wallpapers" "No berserk-*.png / *.jpg found in $dir"
  exit 1
}

# --- changed line: use wofi's dmenu mode ---
choice=$(printf '%s\n' "${wp_list[@]}" | wofi --dmenu --prompt "Choose wallpaper:")

[[ -z "$choice" ]] && exit 0   # cancelled
"$HOME/.config/waybar/set-wallpaper.sh" "$choice"
