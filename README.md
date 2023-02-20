# About this repository

This repository provides a docker configuration for running ioBroker on a smart home server.

## Installation

Run ```docker compose up -d --build``` and two container will start: iobroker and wireguard.

The iobroker-container is the main smart home instance. 

The wireguard-container is meant to establish a connection to the webservice VPN. Although the docker implementation for wireguard client doesn't work properly.
Instead the client for the OS has to be installed (https://www.wireguard.com/install/). After that, the tunnel config (see ./vpn_config/wg0.conf) can be loaded into the wireguard client.

## Checking VPN-Connection

To check if your VPN Connection works properly, do ```ping 10.13.13.4``` (ping to self) and ```ping 10.13.13.1``` (ping to vpn server) in the iobroker docker terminal.
There should be a response in both cases.

Also do ```ping 10.13.13.4``` in the wireguard docker terminal on the vpn server(!) to check, if your vpn server can communicate with the iobroker server.