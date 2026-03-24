#!/usr/bin/env bash

# Hydra Cheatsheet (Rofi)

OPTIONS=$(cat <<EOF
🧠 HYDRA CHEATSHEET

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌨️ KEYBINDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + T        → Terminal
SUPER + B        → Browser
SUPER + V        → VS Code
SUPER + E        → File Manager
SUPER + A        → App Launcher
SUPER + Q        → Close Window
SUPER + L        → Lock Screen
SUPER + P        → Screenshot

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🖐️ GESTURES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3 Finger Left    → Previous Workspace
3 Finger Right   → Next Workspace
3 Finger Up      → Fullscreen
3 Finger Down    → Rofi Launcher

4 Finger Up      → Play / Pause
4 Finger Down    → Next Track
4 Finger Left    → Prev Workspace
4 Finger Right   → Next Workspace

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💡 TIPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Use smooth swipe (not tap)
• Works best with natural scrolling
• Hydra Elite v2 🐉
EOF
)

echo "$OPTIONS" | rofi -dmenu \
-i \
-no-show-icons \
-theme ~/.config/rofi/cheatsheet.rasi
