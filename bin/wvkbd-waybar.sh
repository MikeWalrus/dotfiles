#! /usr/bin/bash

visible=$(hyprctl -j layers | jq 'any(..; type=="object" and .namespace? == "osk")')

if [[ $visible == "false" ]]; then
    printf "\nShow on-screen keyboard"
else
    printf "\nHide on-screen keyboard\nactivated"
fi

