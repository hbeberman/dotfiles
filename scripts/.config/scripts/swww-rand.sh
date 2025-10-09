#!/bin/bash
set -euo pipefail

# Directory with wallpapers
WALLPAPER_DIR="$HOME/.config/wallpapers/misc"

# --- Detect the correct Wayland display from the running swww-daemon ---
SOCKET_DIR="/run/user/$UID"
SOCKET=$(find "$SOCKET_DIR" -maxdepth 1 -type s -name "wayland-*-swww-daemon..sock" | head -n1)

if [ -z "$SOCKET" ]; then
    echo "Error: No swww-daemon socket found in $SOCKET_DIR" >&2
    exit 1
fi

# Extract the display name, e.g. "wayland-1" from the socket path
WAYLAND_DISPLAY=$(basename "$SOCKET" | sed 's/-swww-daemon\.\.sock$//')
export WAYLAND_DISPLAY

# --- Pick a random wallpaper file (non-recursive) ---
FILE=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f | shuf -n 1)

if [ -n "$FILE" ]; then
    echo "Using $FILE on display $WAYLAND_DISPLAY"
    swww img "$FILE"
else
    echo "No files found in $WALLPAPER_DIR" >&2
    exit 1
fi

