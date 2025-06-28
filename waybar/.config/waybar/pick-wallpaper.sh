#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

dir="$HOME/.config/backgrounds"
exts=(png jpg jpeg webp gif)

# Gather all files for each extension
files=()
for ext in "${exts[@]}"; do
  for f in "$dir"/*."$ext"; do
    [[ -f "$f" ]] && files+=("$f")
  done
done

# Natural‑sort the combined list
mapfile -t wp_list < <(
  printf '%s\n' "${files[@]}" \
    | sort -t- -k2,2n
)

# Bail if empty
(( ${#wp_list[@]} )) || {
  notify-send "Wallpapers" "No images found in $dir"
  exit 1
}

# Show with Wofi, no internal resorting
choice=$(
  printf '%s\n' "${wp_list[@]}" \
  | wofi --dmenu \
         --prompt "Choose wallpaper:" \
         --sort-order=default \
         --matching=contains \
         --insensitive
)

# if they picked one, apply it
[[ -n "$choice" ]] && \
"$HOME/.config/waybar/set-wallpaper.sh" "$choice"
