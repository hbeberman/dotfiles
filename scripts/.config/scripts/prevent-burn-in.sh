#!/bin/bash

# Call me every now and then using cron

# Render overlay over bar (swap each call)
hyproled -m1 -s -a 0:0:3840:47

# Read current gaps_out (first value)
current_out=$(hyprctl --instance 0 getoption general:gaps_out -j | jq -r '.custom' | awk '{print $1}')

# Defaults
in="4 4 4 4"
out="6 6 6 6"

# Toggle: if currently 6 → switch to 2/4, else → switch to 3/6
if [[ "$current_out" == "6" ]]; then
    in="2 2 2 2"
    out="3 3 3 3"
fi

# Apply new gaps
hyprctl --instance 0 keyword general:gaps_in "$in"
hyprctl --instance 0 keyword general:gaps_out "$out"

