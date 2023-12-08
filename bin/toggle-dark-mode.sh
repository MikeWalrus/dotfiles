#! /usr/bin/bash

color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)
if [[ $color_scheme == "'prefer-dark'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
elif [[ $color_scheme == "'prefer-light'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
fi
