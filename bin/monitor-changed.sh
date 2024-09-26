#! /usr/bin/sh

notify-send "Monitor configuration changed."

sed -i '/disable/d' ~/.config/hypr/monitors.conf
