# About this repository

This repository provides a docker configuration for running ioBroker on a smart home server.

## Installation

Run ```docker compose up -d --build``` and two container will start: iobroker and wireguard.

The iobroker-container is the main smart home instance. 

The wireguard-container establishes a connection to the webservice VPN. 
Replace the content of the ```./vpn_config/wg0.conf``` (iobroker-repository) with the content of the ```./vpn_config/peer1/peer1.conf``` (webservice-repository).

## Troubleshooting: Docker on Windows
The default wsl2 kernel is not supporting Wireguard out of the box. A custom kernel has to be built and used in Docker.
See https://github.com/bubuntux/nordlynx/issues/81#issuecomment-1163216811 for further information on that.

## Checking VPN-Connection

To check if your VPN Connection works properly, do ```ping 10.13.13.2``` (ping to self) and ```ping 10.13.13.1``` (ping to vpn server) in the iobroker docker terminal.
There should be a response in both cases.
Also do ```ping 10.13.13.2``` in the wireguard docker terminal on the vpn server(!) to check, if your vpn server can communicate with the iobroker server.

## Restoring the backup

https://github.com/buanet/ioBroker.docker/issues/188