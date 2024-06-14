#! /usr/bin/bash

# First, obtain the current PGID, by parsing the output of "ps".
pgid=$(($(ps -o pgid= -p "$$")))

# Check if we're already the process group leader; if not, re-launch ourselves.
# Use setsid instead of set -m (...) to avoid having another subshell in between. This helps that the trap gets executed when the script is killed.
[ $$ -eq $pgid ] || exec setsid --wait "${BASH_SOURCE[0]}" "$@"

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
