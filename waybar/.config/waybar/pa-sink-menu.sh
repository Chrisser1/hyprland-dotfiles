#!/usr/bin/env bash

# 1. Build an array of "name|description" for each sink
mapfile -t SINKS < <(pactl list sinks |
  awk -F': ' '
    /^Sink #/          { next }            # skip numeric header
    /^\s*Name:/        { name=$2 }         # capture the internal name
    /^\s*Description:/ { print name"|"$2 } # emit "name|Description"
  ')

# 2. Menu of descriptions only
MENU=$(printf '%s\n' "${SINKS[@]}" | cut -d'|' -f2)

# 3. Show Wofi menu (limit height to 8 lines to avoid GTK warnings)
CHOICE=$(printf '%s\n' "$MENU" \
         | wofi --dmenu -i -p "Switch audio to:" --lines 8)

# 4. If user selected something, find its name and switch
if [[ -n $CHOICE ]]; then
  # look up the "name|desc" entry that ends with "|$CHOICE"
  SINK_NAME=$(printf '%s\n' "${SINKS[@]}" \
              | grep -F "|$CHOICE" \
              | cut -d'|' -f1)

  # 4a. set default sink by name
  pactl set-default-sink "$SINK_NAME"

  # 4b. ensure it's audible: unmute and set to 75%
  pactl set-sink-mute "$SINK_NAME" false
  pactl set-sink-volume "$SINK_NAME" 50%

  # 4c. move all playing streams to the new sink
  pactl list short sink-inputs \
    | cut -f1 \
    | xargs -r -I{} pactl move-sink-input {} "$SINK_NAME"
fi
