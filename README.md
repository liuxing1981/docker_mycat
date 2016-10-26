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
	edit the start script startup.sh.
	USERNAME=root Username of the mycat.You can use "mysql -u -p" to login.
	PASSWORD=root Password of the mycat.You can use "mysql -u -p" to login.
	DB_NAME=test  The database you use.Make sure all of then mysql instances(master & slaves) 
		      have the same database.If not exits create it. 			  
	MASTER_IP_PORT=192.168.100.7:33306 The ip and port of master server.
	MASTER_USERNAME=root The username of master server.
	MASTER_PASSWORD=root The password of slave server.
	SLAVE_IP_PORT=192.168.100.7:32768,[ip:port] The ip and port of slave server.You also can
						    add many servers as slave to use a comma.
	SLAVE_USERNAME=root,[username] The username of slave server.
	SLAVE_PASSWORD=root,[password] The password of slave server.
	
	run the startup.sh script:
	./startup.sh
	mysql -uroot -proot -h[your host IP] 
	use test;
	select * from t1;
You'll see 2 records.

Conf file is mycat_conf in local path.
You should restart docker after change any config files use:
	docker restart mycat
See how to config your mycat.
	http://www.mycat.org.cn/document/Mycat_V1.6.0.pdf
	
