#!/bin/bash
#usage: ./master.sh [port]
#ex: ./master.sh 33306
#start a mysql server as master port=33306
#by default port=3306


#old_container=$(docker inspect -f '{{.Name}}' $(docker ps -q) | grep master)
#old_container=${old_container#/*}

port=$1
if [ -z $1 ];then
	port=3306
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
container=master$id
#docker rm -f $old_container 2>/dev/null 
MASTER=$(docker run --name $container \
-p $port:3306 \
-v ~/docker/$container:/var/lib/mysql \
-v ${PWD}/init.d:/docker-entrypoint-initdb.d \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci \
--server-id=$id \
--log-bin=mysql-bin \
--gtid-mode=ON \
--enforce-gtid-consistency \
--master-info-repository='TABLE' \
--relay-log-info-repository='TABLE'
)
sleep 10

MASTER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MASTER)

#docker exec $MASTER mysql -uroot -proot -e "
#GRANT REPLICATION SLAVE ON *.* to 'slave'@'%' identified by 'centling';
#flush privileges;
#drop database if exists test;
#create database test;
#use test;
#create table t1 (id int(3),name varchar(10));
#insert into t1 values(1,'master');
#insert into t1 values(2,'master');
#"

echo $MASTER_IP

