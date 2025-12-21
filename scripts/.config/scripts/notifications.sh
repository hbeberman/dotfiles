#!/bin/bash

notifications=$(swaync-client -c)

if [ "$notifications" -gt 0 ]; then
  echo "{\"text\": \"${notifications}❖\", \"class\": \"unread\"}"
else
  echo "{\"text\": \"0❖\", \"class\": \"none\"}"
fi
