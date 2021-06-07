#!/bin/sh
# cmd sleep class

${1} &
sleep "${2}"
wmctrl -x -c "${3}"
