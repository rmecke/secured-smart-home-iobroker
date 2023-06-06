#!/bin/bash

if [ -d "/logs/" ]; then
    while true; do
        timestamp=$(date +%s)
        timestr=$(date '+%D %T (%Z)')
        datestr=$(date '+%d_%m_%Y')
        {
            echo "=============================================="
            echo "Wireguard Status on '$timestamp' | '$timestr':"
            wg show
            echo "=============================================="
        } >> "/logs/wireguard_$datestr.log"
        sleep 60;
    done
fi