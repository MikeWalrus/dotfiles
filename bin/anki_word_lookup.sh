#! /usr/bin/bash

set -e
set -o pipefail

pw-play $(oxford.py "$1") &

goldendict "$1"
