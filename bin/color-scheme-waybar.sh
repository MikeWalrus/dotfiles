#! /usr/bin/bash

color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)
if [[ $color_scheme == "'prefer-dark'" ]]; then
    printf "\nTurn off dark mode"
elif [[ $color_scheme == "'prefer-light'" ]]; then
    printf "\nTurn on dark mode"
fi
