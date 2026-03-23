#!/usr/bin/env bash

echo "⚠️ Removing Hydra configs..."

rm -rf ~/.config/hypr ~/.config/waybar ~/.config/scripts

echo "✅ Hydra removed"
echo "You can restore backup from ~/.config/hydra_backup_*"
