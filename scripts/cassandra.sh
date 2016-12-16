#!/bin/bash

NAME=internal-cassandra

if [ "$(sudo docker ps -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker kill ${NAME}
fi

if [ "$(sudo docker ps -a -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker rm ${NAME}
fi
