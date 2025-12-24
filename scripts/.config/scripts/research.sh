#!/bin/bash
query=$(echo "" | fuzzel --dmenu --prompt "" --width=60 --lines=0)
[[ -z "$query" ]] && exit 0
encoded_query=$(echo -n "$query" | jq -sRr @uri)
firefox --new-tab "https://kagi.com/assistant?profile=ki_research&q=$encoded_query" &
sleep 0.2
#niri msg action focus-window --app-id org.mozilla.firefox
