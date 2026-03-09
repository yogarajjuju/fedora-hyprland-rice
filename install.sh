#!/bin/bash

echo "----------------------------------------"
echo "  🟣 Liquid Glass Hyprland Installer 🟣  "
echo "----------------------------------------"

# 1. Install System Dependencies
echo "📦 Installing dependencies..."
sudo dnf install -y hyprland waybar swaync rofi swww kitty \
brightnessctl wireplumber NetworkManager-tui grim slurp \
jetbrains-mono-fonts-all nwg-look hypridle

# 2. Back up existing configs (just in case)
echo "📂 Backing up old configs..."
mkdir -p ~/.config/hypr_backup
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr_backup/
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/hypr_backup/

# 3. Deploy Liquid Glass Configs
echo "🚀 Deploying new configs..."
cp -r .config/* ~/.config/

# 4. Set permissions
chmod +x ~/.config/hypr/random_wall.sh

echo "----------------------------------------"
echo "✅ Done! Log out and select Hyprland."
echo "Press SUPER + ALT + W to cycle wallpapers."
echo "----------------------------------------"
