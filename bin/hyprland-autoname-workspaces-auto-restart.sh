#!/usr/bin/bash

trap ctrl_c INT

ctrl_c() {
    echo "Exiting."
    exit
}

while true; do
    hyprland-autoname-workspaces
done
