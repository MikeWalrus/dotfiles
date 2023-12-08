#! /usr/bin/bash

GST_DEBUG=3 gst-launch-1.0 pipewiresrc path="$1" ! videoconvert ! autovideosink
