#! /usr/bin/bash

record() {
    local filename="$1"
    local duration="$2"
    ffmpeg \
        -hwaccel vaapi \
        -vaapi_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
        -f pulse \
        -i default \
        -f video4linux2 \
        -i /dev/video0 \
        -vf 'format=nv12,hwupload' \
        -t "$duration" \
        -y \
        -vcodec h264_vaapi \
        -acodec pcm_s16le \
        "$filename"
}

record "$@"
