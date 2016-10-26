#!/bin/bash

container=slave
docker rm -f $container 2>/dev/null 
SLAVE=$(docker run --name $container \
-p 33307:3306 \
-v ~/docker/$container:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci \
--server-id=2 \
--log-bin=mysql-bin \
--gtid-mode=ON \
--enforce-gtid-consistency \
--relay-log=${container}-relay-bin \
--relay-log-index=${container}-relay-bin.index \
--master-info-repository='TABLE' \
--relay-log-info-repository='TABLE'
)

sleep 10

docker exec $SLAVE mysql -uroot -proot -e "
STOP SLAVE FOR CHANNEL '';
reset slave;
CHANGE MASTER TO master_host='$1',
master_port=3306,
master_user='slave',
master_password='centling',
MASTER_AUTO_POSITION=1;
start slave;
show slave status\G
"




