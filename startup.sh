#!/bin/bash
#docker rmi -f liuxing/mycat
#docker build -t liuxing/mycat .
docker rm -f mycat 2>/dev/null
docker run --name mycat -d -v ${PWD}/mycat_conf:/root/mycat/conf -p 3306:8066 mycat

