#!/bin/sh
#
# modprobe i2c-dev
#
# # vim /etc/udev/rules.d/98-ddc.rules
# KERNEL=="i2c-10", SUBSYSTEM=="i2c-dev", GROUP=="ddc", MODE="0660"
# KERNEL=="i2c-18", SUBSYSTEM=="i2c-dev", GROUP=="ddc", MODE="0660"
#
# bindsym XF86MonBrightnessUp exec --no-startup-id "notify-send -h string:x-canonical-private-synchronous:my-backlight -t 800 -u low -a backlight $(~/.local/bin/backlight.sh up)"
# bindsym XF86MonBrightnessDown exec --no-startup-id "notify-send -h string:x-canonical-private-synchronous:my-backlight -t 800 -u low -a backlight $(~/.local/bin/backlight.sh down)"
#

if xrandr | grep --quiet "HDMI1 connected"; then
  DISPLAY=external
else
  DISPLAY=builtin
fi

CMD=${1}
VAL=${2}

case $DISPLAY in
  "external")
    if [ $(( VAL % 20 )) != 0 ]; then
    VAL=$(( VAL/20*20 ))
    [ $VAL -gt 100 ] && VAL=100
    [ $VAL -lt 0 ] && VAL=0
    fi

    DDC='ddccontrol -f -r 0x10'
    DEV='dev:/dev/i2c-1'
    SETCMD="${DDC} -w ${VAL} $DEV"
    UPCMD="${DDC} -W +20 ${DEV}"
    DOWNCMD="${DDC} -W -20 ${DEV}"
    CHECKCMD=' 2>/dev/null | tail -n1 | awk -F\/ "{print \$2}"'
    CHECKCMD="${DDC} ${DEV} ${CHECKCMD}"
    ;;
  "builtin")
    SETCMD="xbacklight -set ${VAL}"
    UPCMD='xbacklight -inc 10'
    DOWNCMD='xbacklight -dec 10'
    CHECKCMD='xbacklight -get'
    ;;
esac

case $CMD in
  "up")
    $UPCMD 1>/dev/null 2>&1;;
  "down")
    $DOWNCMD 1>/dev/null 2>&1;;
  "set")
    $SETCMD 1>/dev/null 2>&1;;
  "detect")
  	echo $DISPLAY
  	exit;;
esac

eval "$CHECKCMD"
