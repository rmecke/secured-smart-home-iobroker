#!/bin/bash
# iobroker start after restore
if [ -f /opt/iobroker/iobroker-data/backitup/.startAll ]; then
cd "/opt/iobroker"
iobroker start all;
fi
sleep 6
gosu root /opt/scripts/maintenance.sh off -y