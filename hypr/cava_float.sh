#!/bin/bash

# kill old instance
killall cava 2>/dev/null

# launch cava
kitty --class cava -e cava &

# wait for window
sleep 0.4

# float it
hyprctl dispatch togglefloating

# resize (match your screen nicely)
hyprctl dispatch resizeactive exact 900 260

# center under waybar (tune Y if needed)
hyprctl dispatch movewindowpixel exact 500 80
