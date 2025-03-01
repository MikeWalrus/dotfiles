#! /usr/bin/bash

read locked < ~/.config/rotation_lock
if [[ $locked == *"true"* ]]; then
    printf "false" > ~/.config/rotation_lock
else
    printf "true" > ~/.config/rotation_lock
fi
