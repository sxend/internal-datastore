#!/bin/bash

DATABASE=$1

NAME=internal-rdb

if [ "$(sudo docker ps -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker kill ${NAME}
fi

if [ "$(sudo docker ps -a -q --filter "NAME=${NAME}" | wc -l)" -eq "1" ]; then
  sudo docker rm ${NAME}
fi

BASE_DIR=$(eval echo ~$USER)/.${NAME} && \
mkdir -p ${BASE_DIR}/var/lib/mysql && \
mkdir -p ${BASE_DIR}/etc/mysql/conf.d && \
aws s3 cp --recursive s3://internal-storage.arimit.su/${NAME}/etc/mysql/conf.d/ ${BASE_DIR}/etc/mysql/conf.d/ && \
sudo docker pull mysql:5.7.17 && \
sudo docker run -it -d --name ${NAME} \
  -v ${BASE_DIR}/var/lib/mysql:/var/lib/mysql \
  -v ${BASE_DIR}/etc/mysql/conf.d:/etc/mysql/conf.d \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=$(aws s3 cp s3://internal-storage.arimit.su/${NAME}/root.pass - ) \
  -e MYSQL_DATABASE=${DATABASE} \
  -e MYSQL_USER=$(aws s3 cp s3://internal-storage.arimit.su/${NAME}/user.name - ) \
  -e MYSQL_PASSWORD=$(aws s3 cp s3://internal-storage.arimit.su/${NAME}/user.pass - ) \
  mysql:5.7.17
