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
NC='\033[0m'

clear
echo "🔄 HYDRA Updater"

git pull origin main >> "$LOG_FILE" 2>&1

BACKUP_DIR=~/.config/hydra_backup_$(date +%s)
mkdir -p "$BACKUP_DIR"

cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/scripts "$BACKUP_DIR/" 2>/dev/null

# Apply safely
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/scripts

[ -d hypr ] && cp -r hypr ~/.config/
[ -d waybar ] && cp -r waybar ~/.config/
[ -d scripts ] && cp -r scripts ~/.config/

chmod +x ~/.config/scripts/*.sh 2>/dev/null

hyprctl reload || true

log "${GREEN}✔ Updated${NC}"