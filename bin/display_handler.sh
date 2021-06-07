#!/usr/bin/env bash

EXTERNAL_REPLACE='xrandr --output eDP1 --off --output HDMI1 --auto --scale 1'

case "$SRANDRD_ACTION" in
        "HDMI1 connected") $EXTERNAL_REPLACE ;;
        *)
                if xrandr | grep "HDMI1 connected"; then
                        $EXTERNAL_REPLACE
                fi
                ;;
esac

sleep 1

pkill telegram-deskto # not a typo ¯\_(ツ)_/¯
telegram-desktop & # ~/.local/bin/hide_on_start.sh telegram-desktop 5 TelegramDesktop
