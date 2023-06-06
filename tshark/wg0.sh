#!/bin/bash

if [ -d "./logs/" ]; then
    mkdir -p ./logs/tshark
    tshark -i wg0 -b duration:3600 -b interval:3600 -b files:24 -F pcapng -w ./logs/tshark/wg0
fi