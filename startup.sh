#!/bin/bash
docker rmi -f liuxing/mycat 2>/dev/null
docker build -t liuxing/mycat .
docker rm -f mycat 2>/dev/null
docker run --name mycat -d \
-v ${PWD}/mycat_conf:/root/mycat/conf \
-e USERNAME=root \
-e PASSWORD=root \
-e DB_NAME=test \
-e MASTER_IP_PORT=192.168.100.7:33306 \
-e MASTER_USERNAME=root \
-e MASTER_PASSWORD=root \
-e SLAVE_IP_PORT=192.168.100.7:32768 \
-e SLAVE_USERNAME=root \
-e SLAVE_PASSWORD=root \
-p 3306:8066 liuxing/mycat
