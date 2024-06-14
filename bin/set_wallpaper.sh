#! /usr/bin/bash

if [[ -z $WAYLAND_DISPLAY ]]; then
    feh --no-fehbg --bg-fill "$(rand_image.sh)"
    exit
fi
# swaymsg 'output "*" bg '$image' fill'

set -e
hyprctl hyprpaper unload all
monitors=$(hyprctl monitors | awk '/Monitor/ {print $2}')
for monitor in $monitors; do
    image=$(rand_image.sh)
    hyprctl hyprpaper preload "$image"
    hyprctl hyprpaper wallpaper "$monitor,$image"
done
