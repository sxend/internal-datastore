#!/bin/bash

CLUSTER_NAME=$1

NAME=cassandra

if [ "$(sudo docker ps -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker kill ${NAME}
fi

if [ "$(sudo docker ps -a -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker rm ${NAME}
fi

BASE_DIR=$(eval echo ~$USER)/.internal-datastore/${NAME} && \
mkdir -p ${BASE_DIR}/var/lib/cassandra && \
sudo docker run --name ${NAME} -it -d  \
  -e CASSANDRA_LISTEN_ADDRESS=auto \
  -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' ${NAME})" \
  -e CASSANDRA_CLUSTER_NAME=${CLUSTER_NAME} \
  -e CASSANDRA_NUM_TOKENS=512 \
  -v /my/own/datadir:/var/lib/cassandra \
  cassandra:3.9
