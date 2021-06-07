#!/usr/bin/env bash

# exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle

pamixer --default-source -t
notify-send -h string:x-canonical-private-synchronous:pamixer -t 1000 -u low -a pamixer "mute: $(pamixer --default-source --get-mute)"
