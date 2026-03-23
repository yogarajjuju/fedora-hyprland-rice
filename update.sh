#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LOG_FILE="hydra-update.log"

log() {
    echo -e "$1"
    echo -e "$(date '+%H:%M:%S') - $1" >> "$LOG_FILE"
}

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

clear

cat << "EOF"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

        HYDRA Updater

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

sleep 1

log "${CYAN}📡 Fetching updates...${NC}"

git pull origin main >> "$LOG_FILE" 2>&1

log "${GREEN}✔ Repository updated${NC}"

#--------------------------------#
# Backup
#--------------------------------#

log "${CYAN}📂 Backing up configs...${NC}"

BACKUP_DIR=~/.config/hydra_backup_$(date +%s)
mkdir -p "$BACKUP_DIR"

cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null

log "${GREEN}✔ Backup created${NC}"

#--------------------------------#
# Apply configs
#--------------------------------#

log "${CYAN}🚀 Applying updates...${NC}"

rm -rf ~/.config/hypr ~/.config/waybar

cp -r hypr ~/.config/
cp -r waybar ~/.config/

chmod +x ~/.config/hypr/random_wall.sh 2>/dev/null

log "${GREEN}✔ Update applied${NC}"

#--------------------------------#
# Reload
#--------------------------------#

log "${CYAN}🔄 Reloading Hyprland...${NC}"
hyprctl reload >> "$LOG_FILE" 2>&1 || true

log "${GREEN}✔ Reload complete${NC}"

#--------------------------------#
# Finish
#--------------------------------#

echo ""
echo -e "${GREEN}✅ HYDRA updated successfully!${NC}"