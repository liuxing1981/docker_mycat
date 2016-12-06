# "${mysql[@]}" is defined in /docker-entrypoint.sh
"${mysql[@]}" -e "
GRANT REPLICATION SLAVE ON *.* to 'slave'@'%' identified by 'centling';
GRANT SELECT,INSERT,UPDATE,DELETE ON *.* to '$MASTER_USERNAME'@'%' identified by '$MASTER_PASSWORD';
flush privileges;
drop database if exists test;
create database test;
use test;
create table t1 (id int(3),name varchar(10));
insert into t1 values(1,'master');
insert into t1 values(2,'master');
"
