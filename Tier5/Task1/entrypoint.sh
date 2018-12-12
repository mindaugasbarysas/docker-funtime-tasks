#!/usr/bin/env bash
iptables -P INPUT DROP
iptables -I INPUT -s $IP -j ACCEPT
xvfb-run --server-args="-screen 0 1024x768x24" -f /tmp/xauth firefox&
x11vnc -display :99 -auth /tmp/xauth
