#!/bin/bash

RDB_PORT=${RDB_PORT:-3306}
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
aws s3 cp --recursive s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/docker-entrypoint-initdb.d/ ${BASE_DIR}/docker-entrypoint-initdb.d/ && \
sudo docker pull mysql:5.7.17 && \
sudo docker run -it --name ${NAME} \
  -v ${BASE_DIR}/var/lib/mysql:/var/lib/mysql \
  -v ${BASE_DIR}/etc/mysql/conf.d:/etc/mysql/conf.d \
  -v ${BASE_DIR}/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
  -p ${RDB_PORT}:3306 \
  -e MYSQL_DATABASE="stub" \
  -e MYSQL_ROOT_PASSWORD=$(aws s3 cp s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/root.pass - ) \
  -e MYSQL_USER=$(aws s3 cp s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/user.name - ) \
  -e MYSQL_PASSWORD=$(aws s3 cp s3://internal-storage.onplatforms.net/internal/datastore/${NAME}/user.pass - ) \
  mysql:5.7.17
