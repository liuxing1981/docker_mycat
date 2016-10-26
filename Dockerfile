FROM openjdk:7-jre
MAINTAINER xing.liu
COPY mycat /root/mycat
EXPOSE 8066
VOLUME ["/root/mycat/conf"]
ENV MYCAT_HOME=/root/mycat
ENV PATH=$PATH:$MYCAT_HOME/bin
CMD ["/root/mycat/bin/mycat","console"]
