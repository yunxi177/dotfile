#!/bin/bash

DEVICE_NAME="at-translated-set-2-keyboard"
CACHE_FILE="$HOME/.cache/laptop-keyboard-disabled"

if [ -f "$CACHE_FILE" ]; then
	rm "$CACHE_FILE"
	hyprctl keyword "device[$DEVICE_NAME]:enabled" 1
	notify-send "内建键盘已启用"
else
	touch "$CACHE_FILE"
	hyprctl keyword "device[$DEVICE_NAME]:enabled" 0
	notify-send "内建键盘已禁用"
fi
