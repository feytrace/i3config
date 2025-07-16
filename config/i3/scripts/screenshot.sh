#!/bin/bash

DIR="$HOME/Pictures/screenshots"
BASE="screenshot_$(date +%Y%m%d)"
EXT=".png"
FILENAME="$DIR/$BASE$EXT"
COUNTER=1

max_counter=$(ls "$DIR" | grep -E "^screenshot_$(date +%Y%m%d)_[0-9]+$EXT" | \
    sed -E "s/^screenshot_$(date +%Y%m%d)_([0-9]+)\.png$/\1/" | sort -n | tail -n 1)

if [ -n "$max_counter" ]; then
    COUNTER=$((max_counter + 1))
fi

FILENAME="$DIR/${BASE}_$COUNTER$EXT"

echo "Saving screenshot as: $FILENAME"

if [ "$1" == "-s" ]; then
    maim -s "$FILENAME"
else
    maim "$FILENAME"
fi
