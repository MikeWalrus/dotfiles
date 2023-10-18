#! /usr/bin/env bash

unset IFS
# shellcheck disable=SC2207
free_space=($(\
    btrfs "fi" usage / -b |
    sed -n -r \
    's/.*Free \(estimated\):[[:space:]]*([[:digit:]]*).*\(min: ([[:digit:]]*)\)/\1 \2/p'
))

estimated=$((free_space[0] / 1024 / 1024 / 1024))
min=$((free_space[1] / 1024 / 1024 / 1024))

printf "%dG\nmin: %dGiB\ndisk" "$estimated" "$min"
