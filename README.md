# About this repository

This repository provides a docker configuration for running ioBroker on a smart home server.

## Restoring the backup
Although this repository consists of a ready-to-use iobroker service, it is recommended to install the iobroker service by restoring the backup.

In iobrokerdata/backups you find a list of several backups. Copy the most recent backup file into the iobrokerdata directory and on next docker startup, it will be installed.
Also delete the backups folder before starting the container.

If the docker container has been started, but you can't access iobroker consider using following workaround: https://github.com/buanet/ioBroker.docker/issues/188

## Installation

Run ```docker compose up -d --build``` and two container will start: iobroker and wireguard.

The iobroker-container is the main smart home instance. 

The wireguard-container establishes a connection to the webservice VPN. 
Replace the content of the ```./vpn_config/wg0.conf``` (iobroker-repository) with the content of the ```./vpn_config/peer1/peer1.conf``` (webservice-repository).

Ensure that the following lines exist in the ```./vpn_config/wg0.conf``` [Interface]-Part:
```PostUp = DROUTE=$(ip route | grep default | awk '{print $3}'); HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route add $HOMENET3 via $DROUTE;ip route add $HOMENET2 dev wg0; ip route add $HOMENET via $DROUTE;iptables -I OUTPUT -d $HOMENET -j ACCEPT;iptables -A OUTPUT -d $HOMENET2 -j ACCEPT; iptables -A OUTPUT -d $HOMENET3 -j ACCEPT;  iptables -A OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route delete $HOMENET; ip route delete $HOMENET2; ip route delete $HOMENET3; iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT; iptables -D OUTPUT -d $HOMENET -j ACCEPT; iptables -D OUTPUT -d $HOMENET2 -j ACCEPT; iptables -D OUTPUT -d $HOMENET3 -j ACCEPT```
(According to: https://www.linuxserver.io/blog/routing-docker-host-and-container-traffic-through-wireguard)

Ensure that the following lines exist in the ```./vpn_config/wg0.conf``` [Peer]-Part:
```AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25```

## Checking VPN-Connection

To check if your VPN Connection works properly, do ```ping 10.13.13.2``` (ping to self) and ```ping 10.13.13.1``` (ping to vpn server) in the iobroker docker terminal.
There should be a response in both cases.
Also do ```ping 10.13.13.2``` in the wireguard docker terminal on the vpn server(!) to check, if your vpn server can communicate with the iobroker server.


## Troubleshooting: Docker on Windows

The default wsl2 kernel is not supporting Wireguard out of the box. A custom kernel has to be built and used in Docker.
See https://github.com/bubuntux/nordlynx/issues/81#issuecomment-1163216811 for further information on that.