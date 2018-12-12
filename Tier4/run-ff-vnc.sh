#!/usr/bin/env bash

xvfb-run --server-args="-screen 0 $SCREEN_DIMENSIONS" -f /tmp/xauth firefox&
x11vnc -display :99 -auth /tmp/xauth
