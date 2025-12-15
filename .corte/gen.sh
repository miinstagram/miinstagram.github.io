#!/bin/bash

# Usage: ./gen_timestamps.sh *.jpg
# or:    ls *.jpg | sort | ./gen_timestamps.sh

sec=0

while read -r file; do
    # Format seconds → HH:MM:SS
    timestamp=$(printf "%02d:%02d:%02d" $((sec/3600)) $(((sec/60)%60)) $((sec%60)))

    printf "%s\t%s\n" "$timestamp" "$file"

    # Add 20 seconds for next file
    sec=$((sec + 3))
done

