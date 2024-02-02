#! /usr/bin/bash

GST_DEBUG=3 gst-launch-1.0 pipewiresrc path="$1" ! videoconvert ! x264enc tune=zerolatency ! filesink location="$2"
