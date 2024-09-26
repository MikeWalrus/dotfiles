#!/usr/bin/bash

on_monitor_removed() {
    if [[ $1 != eDP-1 ]]; then
        sed -i '/disable/d' ~/.config/hypr/monitors.conf
    fi
}

handle() {
    case $1 in
    monitorremoved*) on_monitor_removed "${1/*>>/}";;
    esac
}

socat -U - "UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" |
    while read -r line; do
        handle "$line"
    done
