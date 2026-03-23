#!/bin/sh
while true; do
    # Get battery percentage
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
    # Check if battery is low (10%)
    if [ "$battery" -le 10 ]; then
        hyprctl notify 5 5000 "rgb(ff0000)" "CRITICAL: Battery at ${battery}%! Plug in now!"
        sleep 60 # Check again in a minute
    else
        sleep 300 # Check every 5 minutes if battery is healthy
    fi
done
