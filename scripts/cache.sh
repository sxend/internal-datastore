#!/bin/bash

NAME=cache

if [ "$(sudo docker ps -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker kill ${NAME}
fi

if [ "$(sudo docker ps -a -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker rm ${NAME}
fi

sudo docker run --name ${NAME} -it -d \
  -p 11211:11211 memcached:1.4.33-alpine
