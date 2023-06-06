#!/bin/bash

if [ -d "./logs/" ]; then
    mkdir -p ./logs/tshark
    tshark -i eth0 -f 'udp port 51820' -b duration:3600 -b interval:3600 -b files:24 -F pcapng -w ./logs/tshark/eth0
fi