#!/bin/bash

WINDOW_ID=$(i3-msg -t get_tree | jq -r '.nodes[] | select(.focused == true).window')

if [ -z "$WINDOW_ID" ]; then
  echo "No focused window found."
  exit 1
fi

WINDOW_PROPS=$(i3-msg -t get_tree | jq -r --arg wid "$WINDOW_ID" '.nodes[] | select(.window = ($wid | to number))')

WINDOW_CLASS=$(echo "$WINDOW_PROPS" | jq -r '.window_properties.class')

WINDOW_INSTANCE=$(echo "$WINDOW_PROPS" | jq -r '.window_properties.instance')

if [ -z "$WINDOW_CLASS" ] || [ -z "$WINDOW_INSTANCE" ]; then
  echo "Could not get window class or instance."
  exit 1
fi

i3-msg "exec --no-startup-id $WINDOW_CLASS"
