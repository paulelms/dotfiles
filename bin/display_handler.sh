#!/bin/sh

case "$SRANDRD_ACTION" in
        "HDMI1 connected")
                xrandr --output eDP1 --off --output HDMI1 --auto
                # xrandr --dpi 96
                # [ -f ~/.Xresources.home ] && xrdb -merge ~/.Xresources.home
                ;;
        "HDMI1 disconnected")
                xrandr --output eDP1 --auto --output HDMI1 --off
                # xrandr --dpi 115
                # [ -f ~/.Xresources.outdoor ] && xrdb -merge ~/.Xresources.outdoor
                ;;
        *)
                xrandr --output eDP1 --auto --output HDMI1 --off
                ;;
esac

sleep 1
i3-msg restart

pkill telegram-deskto # not a typo ¯\_(ツ)_/¯
telegram-desktop & # ~/.local/bin/hide_on_start.sh telegram-desktop 5 TelegramDesktop
