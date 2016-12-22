#!/bin/bash

mysql=( mysql --protocol=socket -uroot -hlocalhost --socket=/var/run/mysqld/mysqld.sock)
mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )

create_db () {
  DATABASE=$1
  echo "CREATE DATABASE IF NOT EXISTS \`$DATABASE\` ;" | "${mysql[@]}"
  echo "GRANT ALL ON \`$DATABASE\`.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
  echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
}

create_db "www.onplatforms.net"
create_db "accounts.onplatforms.net"
