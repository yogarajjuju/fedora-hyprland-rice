#!/usr/bin/env bash

export PATH=$PATH:/home/juju/.cargo/bin:/usr/bin:/usr/local/bin

DIR="$HOME/Pictures/Wallpapers"

# pick random wallpaper
WALL=$(find "$DIR" -type f | shuf -n 1)

# start swww if not running
pgrep swww-daemon >/dev/null || swww-daemon &
sleep 0.5

# set wallpaper with smooth transition
swww img "$WALL" --transition-type any --transition-fps 60

# apply wallust colors (IMPORTANT: only once)
wallust run "$WALL"

# update terminal colors
kitty @ set-colors -a ~/.cache/wallust/sequences 2>/dev/null

# restart waybar for new colors
killall waybar
waybar &

# notify
notify-send "🎨 Hydra Theme Updated" "$(basename "$WALL")"
