#!/bin/bash

DIR="$HOME/Pictures/screenshots"  # Fix tilde expansion
BASE="screenshot_$(date +%Y%m%d)"  # Only use the date part (no time)
EXT=".png"
FILENAME="$DIR/$BASE$EXT"
COUNTER=1

# Find the highest counter number for today's screenshots
max_counter=$(ls "$DIR" | grep -E "^screenshot_$(date +%Y%m%d)_[0-9]+$EXT" | \
    sed -E "s/^screenshot_$(date +%Y%m%d)_([0-9]+)\.png$/\1/" | sort -n | tail -n 1)

if [ -n "$max_counter" ]; then
    COUNTER=$((max_counter + 1))
fi

# Construct the final filename with the incremented counter
FILENAME="$DIR/${BASE}_$COUNTER$EXT"

# Debugging output for checking file name
echo "Saving screenshot as: $FILENAME"

# Check if the first argument is '-s'
if [ "$1" == "-s" ]; then
    maim -s "$FILENAME"
else
    maim "$FILENAME"
fi
