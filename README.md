
```bash
BASE_DIR=$(eval echo ~$USER)/.mysql/internal-rdb && \
mkdir -p ${BASE_DIR}/var/lib/mysql && \
mkdir -p ${BASE_DIR}/etc/mysql/conf.d && \
aws s3 cp --recursive s3://internal-storage.arimit.su/internal-rdb/etc/mysql/conf.d/ ${BASE_DIR}/etc/mysql/conf.d/ && \
sudo docker pull mysql:8.0.0 && \
sudo docker kill internal-rdb && sudo docker rm internal-rdb && \
sudo docker run -it -d --name internal-rdb \
  -v ${BASE_DIR}/var/lib/mysql:/var/lib/mysql \
  -v ${BASE_DIR}/etc/mysql/conf.d:/etc/mysql/conf.d \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=$(aws s3 cp s3://internal-storage.arimit.su/internal-rdb/root.pass - ) \
  -e MYSQL_DATABASE=accounts \
  -e MYSQL_USER=$(aws s3 cp s3://internal-storage.arimit.su/internal-rdb/user.name - ) \
  -e MYSQL_PASSWORD=$(aws s3 cp s3://internal-storage.arimit.su/internal-rdb/user.pass - ) \
  mysql:8.0.0
```

