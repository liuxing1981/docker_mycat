This is a docker file for mycat 1.6 release.
First of all you need to install docker.

You should run at least 2 mysql instance firstly for test.
Two servers are mysql docker image file of replication with GTID.
	./master.sh
	./slave.sh [master_ip]
Both mysql server username is root,and password is root.
You can try 
	For master:mysql -uroot -proot -h[your host IP] -P33306 
	For slave: mysql -uroot -proot -h[your host IP] -P33307

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
	
