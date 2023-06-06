#!/bin/bash

if [ -d "./logs/" ]; then
    timestamp=$(date +%s)
    timestr=$(date '+%D %T (%Z)')
    datestr=$(date '+%d_%m_%Y')
    echo "=============================================="; echo "Wireguard Status on '$timestamp' | '$timestr':" >> "./logs/wg_$datestr.log"
    wg show >> "./logs/wg_$datestr.log"
fi