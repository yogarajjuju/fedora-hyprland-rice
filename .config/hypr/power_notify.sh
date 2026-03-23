#!/bin/bash
last_state=$(cat /sys/class/power_supply/AC/online)
while true; do
    current_state=$(cat /sys/class/power_supply/AC/online)
    if [ "$current_state" != "$last_state" ]; then
       if [ "$current_state" == "1" ]; then
    # Charging Icon
    swaync-client -t -sw -c "Power" -b "Charging" -i "battery-charging"
else
    # Discharging Icon
    swaync-client -t -sw -c "Power" -b "On Battery" -i "battery-discharging"
fi
        fi
        last_state=$current_state
    fi
    sleep 2
done

