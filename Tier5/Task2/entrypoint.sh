#!/bin/bash

function exit_required_envvar()
{
    echo "Environment variable $1 is required for the script to work, please set it"
    exit 127
}

# REQUIRED ENVVARS
for required in USERNAME PASSWORD WHITELIST_IPS
do
    if [[ `eval "if [[ -z "'$'"$required ]]; then echo 'no'; else echo 'yes'; fi"` == 'no' ]]
    then
    exit_required_envvar $required
    fi
done

# OPTIONAL ENVVARS
if [[ -z $NAMESERVERS ]]
then
    NAMESERVERS="1.1.1.1 8.8.8.8 8.8.4.4"
fi

if [[ -z $TIMEOUT ]]
then
    TIMEOUT=30
fi

if [[ -z $COUNTRYID ]]
then
    COUNTRYID=81
fi

if [[ -z $WATCHDOG_HOST ]]
then
    WATCHDOG_HOST="1.1.1.1"
fi

echo "" > /etc/resolv.conf
echo -e "using nameservers: "
for ns in $NAMESERVERS
do
    echo -e "$ns "
    echo "nameserver $ns" >> /etc/resolv.conf
done

DEFAULT_GW=`ip route | grep default`
DAS_SERVER=` de465.nordvpn.com`
DOWNLOAD_PATTERN="https://downloads.nordcdn.com/configs/files/ovpn_legacy/servers/$DAS_SERVER.udp1194.ovpn"

echo "using server: $DAS_SERVER"
wget -q "$DOWNLOAD_PATTERN"
echo -e "$USERNAME\n$PASSWORD" > user-auth-file
openvpn --config $DAS_SERVER.udp1194.ovpn --auth-user-pass user-auth-file --daemon

let TO=0
echo -n "connecting:"
while [[ `ip link | grep -c tun` -lt 1 ]]; do
    let TO+=1
    echo -n "."
    sleep 1
    if [[ $TO -gt $TIMEOUT ]]; then
        echo "connection timeout, exiting"
        rm user-auth-file
        exit 128
    fi
done;

rm user-auth-file
echo -e "Setting up firewall / killswitch: "
iptables -F
iptables -t nat -F
iptables -t mangle -F

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A FORWARD -i eth+ -o tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -o eth+ -j ACCEPT

iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE

iptables -I OUTPUT -m state --state=RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT ! -o tun0 -j DROP
echo "OK"

for ip in $WHITELIST_IPS
do
    echo "whitelisting $ip"
    ip route add `echo $ip $DEFAULT_GW | sed -e 's/default//g'`
done

echo "Starting deluged + deluge-web"
sudo -u deluge-webui deluged; sudo -u deluge-webui deluge-web --fork -i 0.0.0.0

#watchdog
sleep 10; while true; do ping -c 3 $WATCHDOG_HOST > /dev/null; if [[ $? -ne 0 ]]; then echo "watchdog killing container - no internet connection"; sleep 120; exit 64; fi; sleep 20; done;
