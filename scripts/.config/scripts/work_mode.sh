#!/bin/bash
# Work mode toggle script for waybar

WORK_DIR="$HOME/.config/work"
WORK_FILE="$WORK_DIR/active"

# Handle click to toggle
if [ "$1" == "toggle" ]; then
    if [ -f "$WORK_FILE" ]; then
        rm "$WORK_FILE"
    else
        mkdir -p "$WORK_DIR"
        touch "$WORK_FILE"
    fi
fi

# Determine if we're in work hours (6am-6pm Mon-Fri)
hour=$(date +%H)
day=$(date +%u)  # 1=Monday, 7=Sunday

if [ "$day" -ge 1 ] && [ "$day" -le 5 ] && [ "$hour" -ge 6 ] && [ "$hour" -lt 18 ]; then
    work_hours=true
else
    work_hours=false
fi

# Output status for waybar
if [ -f "$WORK_FILE" ]; then
    if [ "$work_hours" = true ]; then
        echo '{"text": "󰒓 ", "class": "active-normal", "tooltip": "Work Mode: ON"}'
    else
        echo '{"text": "󰒓 ", "class": "active-overtime", "tooltip": "Work Mode: ON (after hours)"}'
    fi
else
    if [ "$work_hours" = true ]; then
        echo '{"text": "󰒓 ", "class": "inactive-work-hours", "tooltip": "Work Mode: OFF (work hours!)"}'
    else
        echo '{"text": "󰒓 ", "class": "inactive-normal", "tooltip": "Work Mode: OFF"}'
    fi
fi
