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
YELLOW='\033[1;33m'
NC='\033[0m'

#--------------------------------#
# Notification
#--------------------------------#

notify() {
    command -v notify-send &>/dev/null && notify-send "Hydra" "$1"
}

#--------------------------------#
# Progress Bar
#--------------------------------#

progress() {
    local step=$1
    local total=$2
    local percent=$(( step * 100 / total ))
    local filled=$(( percent / 2 ))
    local empty=$(( 50 - filled ))

    printf "\r["
    printf "%0.s#" $(seq 1 $filled)
    printf "%0.s-" $(seq 1 $empty)
    printf "] %d%%" "$percent"
}

#--------------------------------#
# Spinner
#--------------------------------#

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

#--------------------------------#
# Animated Logo
#--------------------------------#

animate_logo() {
for i in {1..3}; do
clear
cat << "EOF"

██╗  ██╗██╗   ██╗██████╗  █████╗
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗
███████║ ╚████╔╝ ██████╔╝███████║
██╔══██║  ╚██╔╝  ██╔══██╗██╔══██║
██║  ██║   ██║   ██║  ██║██║  ██║
╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝

        HYDRA Installer

EOF
sleep 0.3
done
}

animate_logo

TOTAL_STEPS=5
STEP=0

next_step() {
    STEP=$((STEP+1))
    echo -e "\n${PURPLE}Step $STEP/$TOTAL_STEPS${NC}"
}

#--------------------------------#
# System Check
#--------------------------------#

next_step
log "${CYAN}🔍 Checking system...${NC}"

if ! command -v dnf &> /dev/null; then
    log "${RED}❌ Fedora required${NC}"
    exit 1
fi

log "${GREEN}✔ Fedora detected${NC}"
progress $STEP $TOTAL_STEPS

#--------------------------------#
# Menu
#--------------------------------#

echo ""
echo -e "${PURPLE}Select Installation Type${NC}"
echo "1) Full Install"
echo "2) Only Configs"
echo "3) Exit"

read -rp "Choice: " choice

#--------------------------------#
# Dependencies
#--------------------------------#

next_step

if [[ "$choice" == "1" ]]; then
log "${CYAN}📦 Installing dependencies...${NC}"

run sudo dnf copr enable solopasha/hyprland -y

packages=(
hyprland waybar rofi swww kitty brightnessctl
wireplumber NetworkManager-tui grim slurp
)

for pkg in "${packages[@]}"; do
    log "${CYAN}Installing $pkg...${NC}"
    run sudo dnf install -y "$pkg"
done
fi

progress $STEP $TOTAL_STEPS

#--------------------------------#
# Backup
#--------------------------------#

next_step
log "${CYAN}📂 Backing up configs...${NC}"

BACKUP_DIR=~/.config/hydra_backup_$(date +%s)
mkdir -p "$BACKUP_DIR"

run cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
run cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null
run cp -r ~/.config/scripts "$BACKUP_DIR/" 2>/dev/null

progress $STEP $TOTAL_STEPS

#--------------------------------#
# Install
#--------------------------------#

next_step
log "${CYAN}🚀 Installing Hydra configs...${NC}"

mkdir -p ~/.config

run cp -r hypr ~/.config/
run cp -r waybar ~/.config/
run cp -r scripts ~/.config/

chmod +x ~/.config/scripts/*.sh 2>/dev/null

progress $STEP $TOTAL_STEPS

#--------------------------------#
# Finish
#--------------------------------#

next_step
log "${GREEN}✔ Installation Complete${NC}"

progress $STEP $TOTAL_STEPS

notify "Hydra installed successfully"

cat << "EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌊 HYDRA Installation Complete

Enjoy Hydra ✨

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF