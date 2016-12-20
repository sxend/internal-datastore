#!/bin/bash

DATABASE=$1
HOST_PORT=$2
HOST_PORT=${HOST_PORT:-3306}
NAME=rdb

if [ "$(sudo docker ps -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker kill ${NAME}
fi

if [ "$(sudo docker ps -a -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker rm ${NAME}
fi

BASE_DIR=$(eval echo ~$USER)/.internal/datastore/${NAME} && \
mkdir -p ${BASE_DIR}/var/lib/mysql && \
mkdir -p ${BASE_DIR}/etc/mysql/conf.d && \
aws s3 cp --recursive s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/etc/mysql/conf.d/ ${BASE_DIR}/etc/mysql/conf.d/ && \
sudo docker pull mysql:5.7.17 && \
sudo docker run -it -d --name ${NAME} \
  -v ${BASE_DIR}/var/lib/mysql:/var/lib/mysql \
  -v ${BASE_DIR}/etc/mysql/conf.d:/etc/mysql/conf.d \
  -p ${HOST_PORT}:3306 \
  -e MYSQL_ROOT_PASSWORD=$(aws s3 cp s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/root.pass - ) \
  -e MYSQL_DATABASE=${DATABASE} \
  -e MYSQL_USER=$(aws s3 cp s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/user.name - ) \
  -e MYSQL_PASSWORD=$(aws s3 cp s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/user.pass - ) \
  mysql:5.7.17
