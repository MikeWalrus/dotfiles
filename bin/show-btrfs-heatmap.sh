#! /usr/bin/bash

image=/tmp/btrfs_heatmap.png

sudo btrfs-heatmap / -o "$image" && sxiv "$image"
