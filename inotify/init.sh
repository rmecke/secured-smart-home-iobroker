#!/bin/sh

#
# Script options (exit script on command fail).
#
set -e

INOTIFY_EVENTS_DEFAULT="create,delete,modify,move"
INOTIFY_OPTONS_DEFAULT='--monitor --exclude "*.sw[px]"'

#
# Display settings on standard out.
#
echo "inotify settings"
echo "================"
echo
echo "  Volumes:          ${VOLUMES}"
echo "  Inotify_Events:   ${INOTIFY_EVENTS:=${INOTIFY_EVENTS_DEFAULT}}"
echo "  Inotify_Options:  ${INOTIFY_OPTIONS:=${INOTIFY_OPTONS_DEFAULT}}"
echo

#
# Inotify part.
#
echo "[Starting inotifywait...]"
inotifywait -e ${INOTIFY_EVENTS} ${INOTIFY_OPTIONS} "${VOLUMES}" | \
    #while read -r notifies;
    #do
    #	echo "$notifies"
        #echo "notify received, sent signal ${SIGNAL} to container ${CONTAINER}"
        #curl ${CURL_OPTIONS} -X POST --unix-socket /var/run/docker.sock http:/containers/${CONTAINER}/kill?signal=${SIGNAL} > /dev/stdout 2> /dev/stderr
    #done
    while read -r path action file; do
        timestamp=$(date +%s)
        timestr=$(date '+%D %T')
        echo "'$timestamp' | '$timestr' | Directory: '$path' | File: '$file' | Action: '$action'"
        echo "'$timestamp' | '$timestr' | Directory: '$path' | File: '$file' | Action: '$action'" >> ./logs/inotify.log
    done

    