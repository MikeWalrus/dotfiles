#! /usr/bin/bash

TIME=$(date "+%H")
if [ $TIME -lt 18 ] && [ $TIME -gt 5 ]; then
    files=(~/pics/wallpapers/day/*)
else
    files=(~/pics/wallpapers/night/*)
fi

image="${files[RANDOM % ${#files[@]}]}"
printf "%s" "$image"
