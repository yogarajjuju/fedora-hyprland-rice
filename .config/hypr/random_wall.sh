#!/bin/bash
# Start daemon if not running
swww-daemon || swww init

WALL_DIR="/home/juju/Pictures/Wallpapers/"
RANDOM_WALL=$(find "$WALL_DIR" -type f | shuf -n 1)

# Apply the wallpaper and CLEAR the old cache
swww img "$RANDOM_WALL" --transition-type wipe --transition-step 90 --transition-fps 60
