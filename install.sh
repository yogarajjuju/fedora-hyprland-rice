#!/usr/bin/env bash
set -e

#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Liquid Glass Hyprland Installer    |--/ /-|#
#|-/ /--| Created by Yogaraj Juju            |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

clear

cat <<"EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

██╗     ██╗ ██████╗ ██╗   ██╗██╗██████╗
██║     ██║██╔═══██╗██║   ██║██║██╔══██╗
██║     ██║██║   ██║██║   ██║██║██║  ██║
██║     ██║██║▄▄ ██║██║   ██║██║██║  ██║
███████╗██║╚██████╔╝╚██████╔╝██║██████╔╝
╚══════╝╚═╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚═════╝

 Liquid Glass Hyprland
 Installer by Yogaraj Juju

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF


#--------------------------------#
# Spinner Animation
#--------------------------------#

spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r[%c] Installing..." "${spin:$i:1}"
        sleep .1
    done
    printf "\r"
}

#--------------------------------#
# Fedora Detection
#--------------------------------#

echo "🔍 Checking system compatibility..."

if ! command -v dnf &> /dev/null; then
    echo "❌ This installer only supports Fedora."
    exit 1
fi

echo "✔ Fedora detected"
sleep 1


#--------------------------------#
# Install Dependencies
#--------------------------------#

echo ""
echo "📦 Installing dependencies..."

(
sudo dnf copr enable solopasha/hyprland -y
sudo dnf install -y \
hyprland waybar swaync rofi swww kitty \
brightnessctl wireplumber NetworkManager-tui \
grim slurp jetbrains-mono-fonts-all \
nwg-look hypridle
) & spinner

echo "✔ Dependencies installed"


#--------------------------------#
# Backup Configs
#--------------------------------#

echo ""
echo "📂 Backing up existing configs..."

mkdir -p ~/.config/hypr_backup

if [ -d ~/.config/hypr ]; then
    mv ~/.config/hypr ~/.config/hypr_backup/hypr_$(date +%s)
fi

if [ -d ~/.config/waybar ]; then
    mv ~/.config/waybar ~/.config/hypr_backup/waybar_$(date +%s)
fi

echo "✔ Backup completed"


#--------------------------------#
# Install Configs
#--------------------------------#

echo ""
echo "🚀 Installing Liquid Glass configs..."

cp -r .config/* ~/.config/

chmod +x ~/.config/hypr/random_wall.sh

echo "✔ Config installation complete"


#--------------------------------#
# Finish
#--------------------------------#

cat <<"EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟣 Installation Completed

Log out and choose Hyprland session.

Keybinds:
SUPER + ALT + W → Change wallpaper

Enjoy Liquid Glass ✨

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
