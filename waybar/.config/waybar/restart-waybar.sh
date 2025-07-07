#!/usr/bin/env bash

# Kill Waybar and the custom script if running
pkill waybar
pkill -f waybar-spotify

# Restart both
~/.config/waybar/waybar-spotify 0.2 &
waybar &

