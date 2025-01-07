#!/bin/bash
WALLPAPER_DIR="/home/yunxi/Pictures/wallpaper"
SPECIFIC_IMAGE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
swww img "$SPECIFIC_IMAGE" --transition-type outer --transition-pos "center" --transition-fps 60 --transition-duration 1
# wal -i "$SPECIFIC_IMAGE" --cols16
swaync-client --reload-css
