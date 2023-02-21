#!/bin/bash
# restore
gosu iobroker /opt/scripts/maintenance.sh on -y -kbn
sleep 3
if [ -f /opt/iobroker/iobroker-data/backitup/.redis.info ]; then
cd "/opt/iobroker/node_modules/iobroker.backitup/lib"
else
cd "/opt/iobroker/iobroker-data/backitup"
fi
gosu iobroker node restore.js