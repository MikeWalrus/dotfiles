#! /usr/bin/bash

feh --no-fehbg --bg-fill "$(rand_image.sh)"
# swaymsg 'output "*" bg '$image' fill'

set -e
hyprctl hyprpaper unload all
monitors=$(hyprctl monitors | awk '/Monitor/ {print $2}')
for monitor in $monitors; do
    image=$(rand_image.sh)
    hyprctl hyprpaper preload "$image"
    hyprctl hyprpaper wallpaper "$monitor,$image"
done
