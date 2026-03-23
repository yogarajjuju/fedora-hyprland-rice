#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LOG_FILE="hydra-install.log"
VERSION="v1.2"

log() {
    echo -e "$1"
    echo -e "$(date '+%H:%M:%S') - $1" >> "$LOG_FILE"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

spinner() {
    local pid=$!
    local spin='|/-\'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${YELLOW}[%c] Working...${NC}" "${spin:$i:1}"
        sleep 0.1
    done
    printf "\r"
}

run() {
    "$@" >> "$LOG_FILE" 2>&1 &
    spinner
}

progress() {
    local step=$1
    local total=$2
    local percent=$(( step * 100 / total ))
    printf "\rProgress: %d%%\n" "$percent"
}

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

echo "Version: $VERSION"
sleep 1

#--------------------------------#
# System Check
#--------------------------------#

log "${CYAN}🔍 Checking system...${NC}"

if ! command -v dnf &> /dev/null; then
    log "${RED}❌ Fedora required${NC}"
    exit 1
fi

log "${GREEN}✔ Fedora detected${NC}"

#--------------------------------#
# Menu
#--------------------------------#

echo ""
echo -e "${PURPLE}Select Installation Type${NC}"
echo "1) Full Install"
echo "2) Only Configs"
echo "3) Exit"

read -rp "Choice: " choice

if [[ "$choice" == "1" ]]; then
    log "${CYAN}📦 Installing dependencies...${NC}"
    run sudo dnf copr enable solopasha/hyprland -y

    packages=(hyprland waybar rofi swww kitty brightnessctl wireplumber NetworkManager-tui grim slurp)

    for pkg in "${packages[@]}"; do
        log "${CYAN}Installing $pkg...${NC}"
        run sudo dnf install -y "$pkg"
    done
fi

#--------------------------------#
# Backup (FIXED)
#--------------------------------#

log "${CYAN}📂 Backing up configs...${NC}"

BACKUP_DIR=~/.config/hydra_backup_$(date +%s)
mkdir -p "$BACKUP_DIR"

cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/scripts "$BACKUP_DIR/" 2>/dev/null

log "${GREEN}✔ Backup done${NC}"

#--------------------------------#
# Install
#--------------------------------#

log "${CYAN}🚀 Installing Hydra configs...${NC}"

mkdir -p ~/.config

[ -d hypr ] && cp -r hypr ~/.config/
[ -d waybar ] && cp -r waybar ~/.config/
[ -d scripts ] && cp -r scripts ~/.config/

chmod +x ~/.config/scripts/*.sh 2>/dev/null

log "${GREEN}✔ Installation complete${NC}"

echo ""
echo "✅ HYDRA Installed Successfully"