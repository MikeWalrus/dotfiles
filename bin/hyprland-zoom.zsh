#! /usr/bin/zsh

if [[ -z $1 ]]; then
    echo "usage: $0 <+/-zoom_factor>" >&2
    exit
fi

zoom_option=cursor:zoom_factor

current_zoom_level=$(hyprctl getoption "$zoom_option" |
    awk '/float/ {print $2}')
next_zoom_level=$(( current_zoom_level * ($1 + 1) ))

if [[ $next_zoom_level -lt 1.0 ]]; then
    next_zoom_level=1.0
fi

hyprctl keyword "$zoom_option" "$next_zoom_level"
