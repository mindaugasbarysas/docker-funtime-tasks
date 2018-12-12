FROM debian:buster-slim
RUN apt-get update && apt-get install -y net-tools procps ipset iproute2 conntrack iptables openvpn traceroute iputils-ping
RUN apt-get update && apt-get -y install deluged deluge-webui wget sudo
RUN mkdir -p /opt/vpnd-deluge && mkdir -p /var/deluge-data
RUN yes | adduser deluge-webui --disabled-password --disabled-login --quiet --home /var/deluge-data
COPY entrypoint.sh /opt/vpnd-deluge/entrypoint.sh
WORKDIR /opt/vpnd-deluge/
EXPOSE 8112
VOLUME /var/deluge-data
ENTRYPOINT /opt/vpnd-deluge/entrypoint.sh
