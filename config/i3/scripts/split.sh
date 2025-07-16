#!/bin/bash

# i am not sure about the structure of this one
# but maybe eventually I will add rules similar to this

STATE_FILE="/tmp/i3_split_state"

if [ -f "$STATE_FILE" ]; then
  last=$(cat "$STATE_FILE")
else
  last="h"
fi

if [ "$last" = "v" ]; then
  i3-msg split h
  echo "h" > "$STATE_FILE"
else
  i3-msg split v
  echo "v" > "$STATE_FILE"
fi


