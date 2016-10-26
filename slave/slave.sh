#!/bin/bash
MASTER_PORT=$2
if [ -z $2 ];then
	MASTER_PORT=3306
fi
function random()
{
    min=$1;
    max=$2-$1;
    num=$(date +%s+%N);
    ((retnum=num%max+min));
    echo $retnum;
}
id=$(random 1 65535)
container=slave$id
docker rm -f $container 2>/dev/null 
SLAVE=$(docker run --name $container \
-p 33307:3306 \
-v ~/docker/$container:/var/lib/mysql \
-v ${PWD}/init.d:/docker-entrypoint-initdb.d \
-e MYSQL_ROOT_PASSWORD=root \
-e MASTER_HOST=$1 \
-e MASTER_PORT=$MASTER_PORT \
-d mysql \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci \
--server-id=$id \
--log-bin=mysql-bin \
--gtid-mode=ON \
--enforce-gtid-consistency \
--relay-log=${container}-relay-bin \
--relay-log-index=${container}-relay-bin.index \
--master-info-repository='TABLE' \
--relay-log-info-repository='TABLE'
)


#docker exec $SLAVE mysql -uroot -proot -e "
#STOP SLAVE FOR CHANNEL '';
#reset slave;
#CHANGE MASTER TO master_host='$1',
#master_port=$2,
#master_user='slave',
#master_password='centling',
#MASTER_AUTO_POSITION=1;
#start slave;
#show slave status\G
#"




