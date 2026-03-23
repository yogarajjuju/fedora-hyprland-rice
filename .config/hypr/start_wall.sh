#!/bin/bash

pgrep swww-daemon || swww-daemon &
sleep 0.5

swww img ~/Pictures/Wallpapers/wallpaper.jpg || echo "wall fail"
