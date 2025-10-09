#!/bin/bash
id=$(niri msg --json windows | jq '.[] | select(.app_id=="Spotify") | .id' | head -n1)

if [ -n "$id" ]; then
    niri msg action focus-window --id "$id"
fi

