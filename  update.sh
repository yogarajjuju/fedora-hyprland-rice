#!/usr/bin/env bash
set -e

LOG_FILE="hydra-update.log"

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

        HYDRA Updater

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

sleep 1

#--------------------------------#
# Check repo
#--------------------------------#

log "${CYAN}🔍 Checking Hydra repo...${NC}"

if [ ! -d "$HOME/Hydra" ]; then
    log "${RED}❌ Hydra repo not found in ~/Hydra${NC}"
    exit 1
fi

cd "$HOME/Hydra"

log "${GREEN}✔ Repo found${NC}"

#--------------------------------#
# Pull latest changes
#--------------------------------#

log "${CYAN}📡 Fetching updates...${NC}"

git pull origin main >> "$LOG_FILE" 2>&1

log "${GREEN}✔ Repository updated${NC}"

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
# Apply configs
#--------------------------------#

log "${CYAN}🚀 Applying updates...${NC}"

rm -rf ~/.config/hypr ~/.config/waybar

cp -r hypr ~/.config/
cp -r waybar ~/.config/

chmod +x ~/.config/hypr/random_wall.sh 2>/dev/null

log "${GREEN}✔ Update applied successfully${NC}"

#--------------------------------#
# Reload Hyprland
#--------------------------------#

log "${CYAN}🔄 Reloading Hyprland...${NC}"

hyprctl reload >> "$LOG_FILE" 2>&1 || true

log "${GREEN}✔ Reload complete${NC}"

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

🔄 HYDRA Update Complete

Your system is now up to date ✨

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF