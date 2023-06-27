#! /usr/bin/sh

notify-send "Monitor configuration changed."

sleep 5

num_monitor=$(xrandr | awk '$2 == "connected"{print $1}' | wc -l)

if [ $num_monitor -eq 1 ]; then
    notify-send "Only one monitor left."
    xrandr --auto
    xrandr --output eDP1 --primary
    exit 0
fi

xrandr-dmenu.sh
