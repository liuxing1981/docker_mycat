container=master
docker rm -f $container 2>/dev/null 
MASTER=$(docker run --name $container \
-p 33306:3306 \
-v ~/docker/$container:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci \
--server-id=1 \
--log-bin=mysql-bin \
--gtid-mode=ON \
--enforce-gtid-consistency \
--master-info-repository='TABLE' \
--relay-log-info-repository='TABLE'
)
sleep 10

MASTER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MASTER)

docker exec $MASTER mysql -uroot -proot -e "
GRANT REPLICATION SLAVE ON *.* to 'slave'@'%' identified by 'centling';
flush privileges;
drop database if exists test;
create database test;
use test;
create table t1 (id int(3),name varchar(10));
insert into t1 values(1,'master');
insert into t1 values(2,'master');
"

echo $MASTER_IP

