#Docker mycat
This is a docker image mycat 1.6 release.
First of all you need to install docker.


You should run at least 2 mysql instance firstly for test.
Two servers are mysql docker image file of replication with GTID.
You must enter the directory to run shell script like this:
```
	cd master
	./master.sh [port default=3306]
	cd slave
	./slave.sh [master_ip] [master_port default=3306]
```        
Don't run the script like this:  
```
	./master/master.sh
```    
Beacuse you change the value of $PWD implictly.

You also can start other mysql server as slave just use the same command.
```
	cd slave
	./slave.sh [master_ip] [master_port default=3306]
```
Check if all the servers are booted.
```
	docker ps
```
All mysql server username is root,and password is root.

You can try to connect servers like this:

For master:
```
	mysql -uroot -proot -h[your host IP] -P[port]
```        
For slave:
```
	mysql -uroot -proot -h[your host IP] -P[port]
```

##Build docker image
```    
	docker build -t liuxing/mycat .
```        
##Edit the start script startup.sh.

* ####USERNAME
 
  Username of the mycat.You can use "mysql -u -p" to login. ex:USERNAME=root

* ####PASSWORD
  
  Password of the mycat.You can use "mysql -u -p" to login.ex:PASSWORD=root

* ####DB_NAME 

  The database you use.Make sure all of then mysql instances(master & slaves) have the same database.
  
  If you have not created it before,create it before start mycat.
  
  Login to master and use the command as below:
  ```
  	create database test;
  ```
  If you have done the mysql replication,you need not to create the database on slave servers.
  
  Mysql replication can do the job by synchronizing the data of  master server.
  
  ex:DB_NAME=test

* ####MASTER_IP_PORT
  
  The ip and port of master server.ex:MASTER_IP_PORT=192.168.100.7:33306

* ####MASTER_USERNAME
  
  The username of master server. ex:MASTER_USERNAME=root 

* ####MASTER_PASSWORD
  
  The password of slave server.ex:MASTER_PASSWORD=root

* ####SLAVE_IP_PORT

  The ip and port of slave server.You also can add many servers as slave to use a comma.
  
  ex:SLAVE_IP_PORT=192.168.100.7:32768,192.168.100.7:32767 

* ####SLAVE_USERNAME

  The username of slave server.ex:SLAVE_USERNAME=root,tiger

* ####SLAVE_PASSWORD

  The password of slave server.ex:SLAVE_PASSWORD=root,scott

##Startup mycat
```    
	./startup.sh
```       
##Test replication

* Connect to mycat
```
	mysql -uroot -proot -h[your mycat IP] -P[port]
	use test;
	select * from t1;
	insert into t1 values (3,'slave');
	select * from t1;
```
Show the result: 
```
	1  master
	2  master
	3  slave
```
* Connect to master
```
	mysql -uroot -proot -h[your master IP] -P[port]
	use test;
	select * from t1;
```
Show the result: 
```            
	1  master
	2  master
	3  slave
```
* Connect to slave
```
	mysql -uroot -proot -h[your slave IP] -P[port];
	use test;
	select * from t1;
```    
Show the result: 
```
	1  master
	2  master
	3  slave
```

###Test rw-splitting

* Stop the replication of slave by
```
	mysql -uroot -proot -h[your slave IP] -P[port]
	stop slave;
```	
* Insert a record in mycat.
```
	mysql -uroot -proot -h[your mycat IP] -P[port]
	use test;
	insert into t1 values(4,'rw');
	select * from t1;
```
The record is written to master by mycat.So you can't see the record from slave.
Both mycat and slave has the same result: 
```
	1  master
	2  master
	3  slave
``` 
* Connect to master
```
	mysql -uroot -proot -h[your master IP] -P[port]
	use test;
	select * from t1;
```
Show the result at master: 
```
	1  master
	2  master
	3  slave
	4  rw
```
	    
* Recover the replication,connect to slave
```
	mysql -uroot -proot -h[your slave IP] -P[port]
	start slave;
```
The slave server will compelete the replication automaticly from master when slave server is restarted.
So you try to run at slave server.
```	
	select * from t1;
```
Show the result at slave: 
```
	1  master
	2  master
	3  slave
	4  rw
```
Conf file is mycat_conf in local path.
You should restart docker after change any config files use:
```        
	docker restart mycat
```
See how to config your mycat.
        http://www.mycat.org.cn/document/Mycat_V1.6.0.pdf 
