### internal-storage

####internal-rdb command
```bash
curl -s https://s3-ap-northeast-1.amazonaws.com/public.arimit.su/internal/datastore/scripts/rdb.sh | sh -s -- accounts.onplatforms.net
```

#### internal-cassandra
```bash
curl -s https://s3-ap-northeast-1.amazonaws.com/public.arimit.su/internal/datastore/scripts/cassandra.sh | sh -s -- accounts.onplatforms.net
```

#### internal-cache
```bash
curl -s https://s3-ap-northeast-1.amazonaws.com/public.arimit.su/internal/datastore/scripts/cache.sh | sh

curl -s https://s3-ap-northeast-1.amazonaws.com/public.arimit.su/internal/datastore/scripts/cassandra.sh | \
    grep -v SEEDS | sh -s -- accounts.onplatforms.net

curl -s https://s3-ap-northeast-1.amazonaws.com/public.arimit.su/internal/datastore/scripts/cassandra.sh | \
    sed -e "s/NAME=cassandra/NAME=cassandra-node-$(date +%s)/" | sh -s -- accounts.onplatforms.net
```
