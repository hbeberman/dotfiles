#!/bin/bash
flatpak run app.zen_browser.zen --new-tab https://www.chatgpt.com &
sleep 0.2
niri msg action focus-window --app-id zen-alpha
