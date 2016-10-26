#!/bin/bash
#docker rmi -f liuxing/mycat
#docker build -t liuxing/mycat .
#docker rm -f liuxing/mycat 2>/dev/null
docker run --name liuxing/mycat -d -v ${PWD}/mycat_conf:/root/mycat/conf -p 3306:8066 mycat

