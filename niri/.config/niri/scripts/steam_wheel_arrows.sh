#!/bin/sh
# Send left/right arrow presses when the specified Steam app is focused.

set -eu

TARGET_APP_ID="steam_app_238960"

if [ "$#" -ne 1 ]; then
    exit 0
fi

case "$1" in
    up) keycode=105 ;;   # KEY_LEFT
    down) keycode=106 ;; # KEY_RIGHT
    *) exit 0 ;;
esac

NIRI_BIN="${NIRI_BIN:-$(command -v niri || true)}"
JQ_BIN="${JQ_BIN:-$(command -v jq || true)}"
YDO_BIN="${YDO_BIN:-$(command -v ydotool || true)}"

if [ -z "$NIRI_BIN" ] || [ -z "$JQ_BIN" ] || [ -z "$YDO_BIN" ]; then
    exit 0
fi

focused_json=$("$NIRI_BIN" msg -j focused-window 2>/dev/null || exit 0)
app_id=$(printf '%s' "$focused_json" | "$JQ_BIN" -r '.app_id // empty' 2>/dev/null || printf '')

if [ "$app_id" != "$TARGET_APP_ID" ]; then
    exit 0
fi

# ydotoold must be running for this to succeed.
"$YDO_BIN" key "${keycode}:1" "${keycode}:0" >/dev/null 2>&1 || true
