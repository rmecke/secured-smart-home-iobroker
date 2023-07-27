# About this repository

This repository provides a docker configuration for running ioBroker on a smart home server. Also it provides useful utilities for forensic readiness.
The main docker configuration consists of 5 images/containers (docker-compose.yml):
- **wireguard**: Enables the VPN-Tunneling through the WireGuard-Protocol. This is needed for a secure connection with the Webservice.
- **iobroker**: The actual smart home.
- **wireshark** (optional): Live analysis of network activities. Traffic could be observed from another device in home network via browser.
- **inotify** (optional): Mass storage logging. File activities related to the iobrokerdata-directory will be catched and written to logfiles.
- **tshark** (optional): Network logging. Network activities related to the wg0- and eth0-interface will be catched and written to logfiles.

The additional docker configuration consists of 6 images/containers (docker-compose-monitoring.yml):
- **Grafana** (optional): Visualisation platform for monitoring and logging overview.
- **Prometheus** (optional): Collect the statistics from Node-Exporter and cAdvisor for later visualisation in Grafana.
- **Node-Exporter** (optional): Provide hardware/system statistics.
- **cAdvisor** (optional): Provide docker container statistics.
- **Loki** (optional): Collect the logging data from Promtail for later visualisation in Grafana.
- **Promtail** (optional): Retrieve logfiles and provide preprocessed logging data.

## Installation

### Adapt the settings inside docker compose file
Configure the ```docker-compose.yml``` and ```docker-compose-monitoring.yml``` according to the desired setup. Also check, which optional services are necessary and, if admin-credentials are listed in the compose-file, change the credentials to secret ones.

### Restore the iobroker-backup
It is recommended to install the iobroker service by restoring the backup.

In iobrokerdata/backups you find a list of several backups. Copy the most recent backup file into the iobrokerdata directory and on next docker startup, it will be installed.
Also delete the backups folder before starting the container.

If the docker container has been started, but you can't access iobroker consider using following workaround: https://github.com/buanet/ioBroker.docker/issues/188

### Ensure correct wireguard-settings

The wireguard-container establishes a connection to the webservice VPN. 

First you need to start the webservice including the Wireguard VPN-Server. Therefore visit the webservice-repository. There, some peer config-files will be generated. Those are needed for the following steps.

Replace the content of the ```./vpn_config/wg0.conf``` (iobroker-repository) with the content of the ```./vpn_config/peer1/peer1.conf``` (webservice-repository).

Ensure that the following lines exist in the ```./vpn_config/wg0.conf``` [Interface]-Part:

```PostUp = DROUTE=$(ip route | grep default | awk '{print $3}'); HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route add $HOMENET3 via $DROUTE;ip route add $HOMENET2 dev wg0; ip route add $HOMENET via $DROUTE;iptables -I OUTPUT -d $HOMENET -j ACCEPT;iptables -A OUTPUT -d $HOMENET2 -j ACCEPT; iptables -A OUTPUT -d $HOMENET3 -j ACCEPT;  iptables -A OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT```
```PreDown = HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route delete $HOMENET; ip route delete $HOMENET2; ip route delete $HOMENET3; iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT; iptables -D OUTPUT -d $HOMENET -j ACCEPT; iptables -D OUTPUT -d $HOMENET2 -j ACCEPT; iptables -D OUTPUT -d $HOMENET3 -j ACCEPT```

(According to: https://www.linuxserver.io/blog/routing-docker-host-and-container-traffic-through-wireguard)

Ensure that the following lines exist in the ```./vpn_config/wg0.conf``` [Peer]-Part:

```AllowedIPs = 0.0.0.0/0```

```PersistentKeepalive = 25```

### Start the containers

Run ```docker compose up -d --build``` and at least two containers will start: iobroker and wireguard. The other containers are optional.

Run ```docker compose -f docker-compose-monitoring.yml up -d --build``` to start the optional monitoring related containers. These are all optional, according to their additional overhead.

### Adapt the ioBroker configuration
The default username is: ```admin```. The default password is: ```SecuredSmartHome23```. Please change them in order to provide a secure smart home instance.

Also there are several credentials left out inside the ioBroker instances tab ("x" marks the spot). These are:
- Cloud: APP-KEY
- myQ: Username/email
- myQ: Password
- Nanoleaf: Authentification token
- Telegram: Token
- Vis: License

If the according functionality is needed, please create your own accounts and/or derive own application keys.


### Checking VPN-Connection

To check if your VPN Connection works properly, do ```ping 10.13.13.2``` (ping to self) and ```ping 10.13.13.1``` (ping to vpn server) in the iobroker docker terminal.
There should be a response in both cases.
Also do ```ping 10.13.13.2``` in the wireguard docker terminal on the vpn server(!) to check, if your vpn server can communicate with the iobroker server.

## Troubleshooting

### Monitoring: Enable cgroups

Edit the /boot/cmdline.txt as following:
```cgroup_enable=cpuset```
```cgroup_enable=memory```
```cgroup_memory=1```.

After that, restart the device with ```sudo reboot```.


### Docker on Windows

The default wsl2 kernel is not supporting Wireguard out of the box. A custom kernel has to be built and used in Docker.
See https://github.com/bubuntux/nordlynx/issues/81#issuecomment-1163216811 for further information on that.
