#! /usr/bin/bash

read locked < ~/.config/rotation_lock
if [[ $locked == *"true"* ]]; then
    printf "\nunlock rotation"
else
    printf "\nlock rotation"
fi
