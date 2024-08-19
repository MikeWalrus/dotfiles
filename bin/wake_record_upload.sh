#! /usr/bin/bash

timestamp() {
    date -d "today" +"%Y%m%d%H%M"
}

battery() {
    upower -i /org/freedesktop/UPower/devices/battery_BAT1 | sed -rn 's/.*percentage.*:\s*([[:digit:]]*)%/\1/p'
}

main() {
    local duration=$1
    local sleep_time=$2

    while true; do
        local local_filename
        local_filename=tmp_record.mp4
        remote_filename="$(timestamp)_$(battery)".mp4
        record_webcam.sh "$local_filename" "$duration"

        local base_url
        base_url="https://mike:2wY6xceUDRE3UV@static.junxuanliao.com/dav/vid"
        curl \
            --noproxy '*' \
            -T "$local_filename" \
            "$base_url/$remote_filename"
        sudo rtcwake -u -m mem -s "$sleep_time"
        sleep 5
    done
}

main "$@"
