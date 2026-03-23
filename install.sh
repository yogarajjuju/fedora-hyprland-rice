#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LOG_FILE="hydra-install.log"
VERSION="v2.0-elite"

#-------------------#
# UI + COLORS
#-------------------#

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "$1"
    echo -e "$(date '+%H:%M:%S') - $1" >> "$LOG_FILE"
}

step=0
total=6

progress() {
    step=$((step+1))
    percent=$(( step * 100 / total ))
    printf "${PURPLE}[%d/%d] (%d%%)${NC}\n" "$step" "$total" "$percent"
}

spinner() {
    local pid=$1
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
    spinner $!
    wait $!
}

#-------------------#
# HEADER
#-------------------#

clear

cat << "EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

██╗  ██╗██╗   ██╗██████╗  █████╗
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗
███████║ ╚████╔╝ ██████╔╝███████║
██╔══██║  ╚██╔╝  ██╔══██╗██╔══██║
██║  ██║   ██║   ██║  ██║██║  ██║
╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝

        HYDRA ELITE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

echo "Version: $VERSION"
sleep 1

#-------------------#
# DISTRO DETECTION
#-------------------#

progress
log "${CYAN}🔍 Detecting system...${NC}"

if command -v dnf &> /dev/null; then
    DISTRO="fedora"
elif command -v pacman &> /dev/null; then
    DISTRO="arch"
else
    log "${RED}❌ Unsupported distro${NC}"
    exit 1
fi

log "${GREEN}✔ Detected: $DISTRO${NC}"

#-------------------#
# MENU
#-------------------#

echo ""
echo -e "${PURPLE}Select Installation Type${NC}"
echo "1) Full Install"
echo "2) Only Configs"
echo "3) Exit"

read -rp "Choice: " choice

[[ "$choice" == "3" ]] && exit 0

#-------------------#
# INSTALL PACKAGES
#-------------------#

progress

if [[ "$choice" == "1" ]]; then
    log "${CYAN}📦 Installing dependencies...${NC}"

    if [[ "$DISTRO" == "fedora" ]]; then
        run sudo dnf copr enable solopasha/hyprland -y
        run sudo dnf install -y hyprland waybar rofi swww kitty brightnessctl wireplumber NetworkManager-tui grim slurp
    fi

    if [[ "$DISTRO" == "arch" ]]; then
        run sudo pacman -S --noconfirm hyprland waybar rofi swww kitty brightnessctl wireplumber networkmanager grim slurp
    fi
fi

#-------------------#
# BACKUP + ROLLBACK
#-------------------#

progress

log "${CYAN}📂 Creating backup...${NC}"

BACKUP_DIR="$HOME/.config/hydra_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

[ -d "$HOME/.config/hypr" ] && cp -r "$HOME/.config/hypr" "$BACKUP_DIR/"
[ -d "$HOME/.config/waybar" ] && cp -r "$HOME/.config/waybar" "$BACKUP_DIR/"
[ -d "$HOME/.config/scripts" ] && cp -r "$HOME/.config/scripts" "$BACKUP_DIR/"

log "${GREEN}✔ Backup saved → $BACKUP_DIR${NC}"

rollback() {
    log "${RED}⚠️ Error occurred! Rolling back...${NC}"

    rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/scripts"

    cp -r "$BACKUP_DIR/"* "$HOME/.config/" 2>/dev/null || true

    log "${GREEN}✔ Rollback completed${NC}"
}

trap rollback ERR

#-------------------#
# INSTALL CONFIGS
#-------------------#

progress

log "${CYAN}🚀 Installing configs...${NC}"

rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/scripts"

[ -d hypr ] && cp -r hypr "$HOME/.config/"
[ -d waybar ] && cp -r waybar "$HOME/.config/"
[ -d scripts ] && cp -r scripts "$HOME/.config/"

chmod +x "$HOME/.config/scripts/"*.sh 2>/dev/null || true

log "${GREEN}✔ Config installation done${NC}"

#-------------------#
# FINAL
#-------------------#

progress

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ HYDRA ELITE INSTALLED SUCCESSFULLY${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Backup: $BACKUP_DIR"
echo "🔄 Restart Hyprland"
echo ""
