#!/usr/bin/env bash
set -e

#--------------------------------#
# Colors
#--------------------------------#

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

cat << "EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

██╗     ██╗ ██████╗ ██╗   ██╗██╗██████╗
██║     ██║██╔═══██╗██║   ██║██║██╔══██╗
██║     ██║██║   ██║██║   ██║██║██║  ██║
██║     ██║██║▄▄ ██║██║   ██║██║██║  ██║
███████╗██║╚██████╔╝╚██████╔╝██║██████╔╝
╚══════╝╚═╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚═════╝

 Liquid Glass Hyprland
 Installer by Yogaraj Juju

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

sleep 1

#--------------------------------#
# Fedora check
#--------------------------------#

echo -e "${CYAN}🔍 Checking system...${NC}"

if ! command -v dnf &> /dev/null; then
    echo -e "${RED}❌ Unsupported distro. Fedora required.${NC}"
    exit 1
fi

echo -e "${GREEN}✔ Fedora detected${NC}"

sleep 1

#--------------------------------#
# GPU Detection
#--------------------------------#

echo -e "${CYAN}🧠 Detecting GPU...${NC}"

if lspci | grep -i nvidia &>/dev/null; then
    GPU="nvidia"
elif lspci | grep -i amd &>/dev/null; then
    GPU="amd"
else
    GPU="intel"
fi

echo -e "${GREEN}✔ GPU detected: $GPU${NC}"

#--------------------------------#
# Menu
#--------------------------------#

echo ""
echo -e "${PURPLE}Select Installation Type${NC}"

echo "1) Full Install"
echo "2) Only Configs"
echo "3) Exit"

read -rp "Choice: " choice

case $choice in

1)

echo -e "${CYAN}📦 Installing dependencies...${NC}"

sudo dnf copr enable solopasha/hyprland -y

sudo dnf install -y \
hyprland \
waybar \
swaync \
rofi \
swww \
kitty \
brightnessctl \
wireplumber \
NetworkManager-tui \
grim \
slurp \
jetbrains-mono-fonts-all \
nwg-look \
hypridle

;;

2)

echo -e "${CYAN}Skipping package installation${NC}"

;;

3)

echo "Exiting installer"
exit 0

;;

*)

echo -e "${RED}Invalid option${NC}"
exit 1

;;

esac

#--------------------------------#
# Backup configs
#--------------------------------#

echo ""
echo -e "${CYAN}📂 Backing up configs...${NC}"

mkdir -p ~/.config/hypr_backup

[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr_backup/hypr_$(date +%s)
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/hypr_backup/waybar_$(date +%s)

echo -e "${GREEN}✔ Backup complete${NC}"

#--------------------------------#
# Deploy configs
#--------------------------------#

echo ""
echo -e "${CYAN}🚀 Installing Liquid Glass configs...${NC}"

cp -r .config/* ~/.config/

chmod +x ~/.config/hypr/random_wall.sh

echo -e "${GREEN}✔ Config installation finished${NC}"

#--------------------------------#
# Finish
#--------------------------------#

echo ""

cat << "EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟣 Installation Complete

Log out and select Hyprland session.

Keybind:
SUPER + ALT + W → Change wallpaper

Enjoy Liquid Glass ✨

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
