#!/usr/bin/env bash

docker run php:5.6-fpm --net=host
docker run nginx --net=host
