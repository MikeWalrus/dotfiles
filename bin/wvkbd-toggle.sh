#! /usr/bin/bash

/usr/bin/pkill -RTMIN wvkbd-mobintl
sleep 0.5
pkill --exact --signal=RTMIN+4 waybar
