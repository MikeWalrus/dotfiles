#! /usr/bin/bash

connect_wayland() {
    socat - UNIX-CONNECT:"$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" >/dev/null
}

main() {
    "$@" &
    connect_wayland &
    wait -n
}

on_exit() {
    trap - SIGTERM
    kill 0
}

trap on_exit SIGINT SIGTERM EXIT

main "$@"
