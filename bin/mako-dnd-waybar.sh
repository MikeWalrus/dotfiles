#! /usr/bin/bash

if makoctl mode | grep dnd > /dev/null; then
    printf "\nTurn on Notification"
else
    printf "\nTurn off Notification"
fi
