#! /usr/bin/sh

config=$(printf "External only\nLeft\nRight\nAbove\nBelow" | dmenu -i)

monitors=$(xrandr | awk '$2 == "connected"{print $1}')

num_monitor=$(printf "%s\n" "$monitors" | wc -l)

echo $num_monitor

if [ $num_monitor -ne 2 ]; then
    dmenu -p "# of monitor != 2"
    exit
fi

external_monitor=$(printf "%s\n" "$monitors" | grep -v "eDP")

echo $external_monitor

case $config in
"External only")
    xrandr --output eDP1 --off --output ${external_monitor} --auto
    xrandr --output ${external_monitor} --primary
    exit 0
    ;;
Left)
    position=--left-of
    ;;
Right)
    position=--right-of
    ;;
Above)
    position=--above
    ;;
Below)
    position=--below
    ;;
*)
    exit 1
    ;;
esac

xrandr --output eDP1 --auto --output $external_monitor --auto $position eDP1
~/.fehbg
