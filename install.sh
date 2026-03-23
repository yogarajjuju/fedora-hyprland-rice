#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LOG_FILE="hydra-install.log"

#--------------------------------#
# Logging
#--------------------------------#

log() {
    echo -e "$1"
    echo -e "$(date '+%H:%M:%S') - $1" >> "$LOG_FILE"
}

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

██╗  ██╗██╗   ██╗██████╗  █████╗
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗
███████║ ╚████╔╝ ██████╔╝███████║
██╔══██║  ╚██╔╝  ██╔══██╗██╔══██║
██║  ██║   ██║   ██║  ██║██║  ██║
╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝

        HYDRA Installer

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

sleep 1

#--------------------------------#
# Fedora check
#--------------------------------#

log "${CYAN}🔍 Checking system...${NC}"

if ! command -v dnf &> /dev/null; then
    log "${RED}❌ Unsupported distro. Fedora required.${NC}"
    exit 1
fi

log "${GREEN}✔ Fedora detected${NC}"

#--------------------------------#
# Dependency Installer
#--------------------------------#

install_pkg() {
    if rpm -q "$1" &> /dev/null; then
        log "${GREEN}✔ $1 already installed${NC}"
    else
        log "${CYAN}Installing $1...${NC}"
        sudo dnf install -y "$1" >> "$LOG_FILE" 2>&1
    fi
}

#--------------------------------#
# Menu
#--------------------------------#

echo ""
echo -e "${PURPLE}Select Installation Type${NC}"
echo "1) Full Install (Recommended)"
echo "2) Only Configs"
echo "3) Exit"

read -rp "Choice: " choice

case $choice in

1)

log "${CYAN}📦 Installing dependencies...${NC}"

sudo dnf copr enable solopasha/hyprland -y >> "$LOG_FILE" 2>&1

packages=(
hyprland waybar swaync rofi swww kitty brightnessctl
wireplumber NetworkManager-tui grim slurp
jetbrains-mono-fonts-all nwg-look hypridle
)

for pkg in "${packages[@]}"; do
    install_pkg "$pkg"
done

;;

2)

log "${CYAN}Skipping package installation${NC}"

;;

3)

echo "Exiting installer"
exit 0

;;

*)

log "${RED}Invalid option${NC}"
exit 1

;;

esac

#--------------------------------#
# Backup configs
#--------------------------------#

log "${CYAN}📂 Backing up configs...${NC}"

BACKUP_DIR=~/.config/hydra_backup_$(date +%s)
mkdir -p "$BACKUP_DIR"

cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null

log "${GREEN}✔ Backup stored in $BACKUP_DIR${NC}"

#--------------------------------#
# Deploy configs
#--------------------------------#

log "${CYAN}🚀 Installing Hydra configs...${NC}"

mkdir -p ~/.config

cp -r hypr ~/.config/
cp -r waybar ~/.config/

chmod +x ~/.config/hypr/random_wall.sh 2>/dev/null

log "${GREEN}✔ Config installation finished${NC}"

#--------------------------------#
# Rollback option
#--------------------------------#

echo ""
read -rp "Do you want to rollback changes? (y/N): " rollback

if [[ "$rollback" == "y" || "$rollback" == "Y" ]]; then
    log "${RED}🔄 Rolling back...${NC}"

    rm -rf ~/.config/hypr ~/.config/waybar
    cp -r "$BACKUP_DIR"/* ~/.config/

    log "${GREEN}✔ Rollback completed${NC}"
    exit 0
fi

#--------------------------------#
# Finish
#--------------------------------#

cat << "EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌊 HYDRA Installation Complete

Log out and select Hyprland session.

Enjoy Hydra ✨
Minimal. Fluid. Beautiful.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF