#! /usr/bin/bash

bwrap \
    --unshare-all \
    --ro-bind /usr /usr \
    --symlink /usr/bin /bin \
    --symlink /usr/lib /lib \
    --symlink /usr/lib /lib64 \
    --symlink /usr/bin /sbin \
    --ro-bind /etc/fonts /etc/fonts \
    --ro-bind /etc/passwd /etc/passwd \
    --ro-bind /etc/localtime /etc/localtime \
    --dir /tmp \
    --dir /var \
    --dev /dev \
    --dev-bind /dev/dri /dev/dri \
    --dev-bind /dev/snd/seq /dev/snd/seq \
    --ro-bind /sys/dev/char /sys/dev/char \
    --ro-bind /sys/devices /sys/devices \
    --ro-bind /sys/class /sys/class \
    --ro-bind /usr/share/drirc.d /usr/share/drirc.d \
    --clearenv \
    --setenv PATH /usr/local/sbin:/usr/local/bin:/usr/bin \
    --setenv WAYLAND_DISPLAY "$WAYLAND_DISPLAY" \
    --setenv XDG_RUNTIME_DIR '/run/user/1000' \
    --setenv HOME ~ \
    --setenv TERM "$TERM" \
    --proc /proc \
    --ro-bind /run/user/1000/pulse /run/user/1000/pulse \
    --ro-bind "$XDG_RUNTIME_DIR/pipewire-0" "$XDG_RUNTIME_DIR/pipewire-0" \
    --ro-bind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" \
    --dev-bind ~/tmp/wine ~/.wine --chdir ~/.wine/drive_c/GAMES/RoadRash \
    --bind ~/docs/backup/roadrash "$(xdg-user-dir DESKTOP)" \
    --ro-bind ~/.config/fontconfig ~/.config/fontconfig \
    --bind ~/.cache/fontconfig ~/.cache/fontconfig \
    -- \
    gamescope -F nearest -S fit -W 640 -H 480 -r 60 -- wine ./Roadrash.exe
