This is a docker file for mycat 1.6 release.
First of all you need to install docker.

You should run at least 2 mysql instance firstly for test.
Two servers are mysql docker image file of replication with GTID.
	./master.sh [port default=3306]
	./slave.sh [master_ip] [master_port default=3306]

You also can start other mysql server as slave just use the same command.
	./slave.sh [master_ip] [master_port default=3306]

Check if all the servers are booted.
	docker ps

All mysql server username is root,and password is root.
You can try 
	For master:mysql -uroot -proot -h[your host IP] -P[port]
	For slave: mysql -uroot -proot -h[your host IP] -P[port]
to connect servers.

mycat usage:
	docker build -t liuxing/mycat .
	./startup.sh
	mysql -uroot -proot -h[your host IP] 
	use test;
	select * from t1;
You'll see 2 records.

Conf file is my_conf in local path.
You should restart docker after change any config files use:
	docker restart mycat
See how to config your mycat.
	http://www.mycat.org.cn/document/Mycat_V1.6.0.pdf
	
