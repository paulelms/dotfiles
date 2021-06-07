#!/bin/bash
# OnSongChange = "/home/username/.local/bin/moc-notify.sh %a %r %t %f %n %d %D"

ARTIST=$1
ALBUM=$2
TITLE=$3
FILENAME=$4
TRACK=$5
DURATION=$6
DURATION_SEC=$7

DEFAULT_ICON=/usr/share/icons/Papirus/24x24/categories/audio-player.svg
APPNAME=mocp

function get_art() {
	FILE=${1}

	DIR=$(dirname -- "${FILE}")
	#DIR=$(realpath "${DIR}")
	COVER=$(find "${DIR}" -type f | grep -E -i '(folder|cover)\.(png|jpg)' | head -n1)

	if [[ -f "${COVER}" ]]; then
		echo "${COVER}"
		return 0
	fi
	
	ffmpeg -i "${FILE}" /tmp/my-moc-cover.jpg
	if [[ -f /tmp/my-moc-cover.jpg ]]; then
		echo /tmp/my-moc-cover.jpg
		return 0
	fi

	echo ${DEFAULT_ICON}
}

ICON=$(get_art "${FILENAME}")
# notify-send не всегда подхватывает cover как иконку
/usr/bin/dunstify -h string:x-canonical-private-synchronous:mocp -t 4000 -u low -i "${ICON}" -a "${APPNAME}" "${ARTIST}" "${TITLE}"

if [[ -f /tmp/my-moc-cover.jpg ]]; then
	rm /tmp/my-moc-cover.jpg
fi
