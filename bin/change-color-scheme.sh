#!/usr/bin/bash

set_btop_theme() {
    local theme=$1
    sed -i 's|color_theme = ".*"|color_theme = "'"$theme"'"|g' ~/.config/btop/btop.conf
}

to_dark() {
    ln -sf ~/.config/alacritty/{dark.toml,color.toml}
    set_btop_theme /usr/share/btop/themes/dracula.theme
    echo dark
}

to_light() {
    ln -sf ~/.config/alacritty/{light.toml,color.toml}
    set_btop_theme /usr/share/btop/themes/whiteout.theme
    echo light
}

on_change() {
    pkill --signal=RTMIN+1 waybar
}

connect_wayland_socket() {
    socat - UNIX-CONNECT:"$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" >/dev/null
}

main() {
    dbus-monitor "interface='org.freedesktop.portal.Settings',member='SettingChanged'" |
        while read -r line; do
            if [[ $line =~ .*prefer-(.*)\" ]]; then
                color="${BASH_REMATCH[1]}"
                if [[ $color == "light" ]]; then
                    to_light
                elif [[ $color == "dark" ]]; then
                    to_dark
                fi
                on_change
            fi
        done
}

main
