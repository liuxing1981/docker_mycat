#!/bin/bash
OLD_IFS=”$IFS”
IFS=”,”
SERVER=($SLAVE_IP_PORT)
SLAVE_USERNAMES=($SLAVE_USERNAME)
SLAVE_PASSWORDS=($SLAVE_PASSWORD)
IFS=”$OLD_IFS”
cp ${MYCAT_HOME}/conf/schema.xml.bak ${MYCAT_HOME}/conf/schema.xml
sed -i \
    -e "s/\${DB_NAME}/$DB_NAME/g" \
    -e "s/\${MASTER_IP_PORT}/$MASTER_IP_PORT/g" \
    -e "s/\${MASTER_USERNAME}/$MASTER_USERNAME/g" \
    -e "s/\${MASTER_PASSWORD}/$MASTER_PASSWORD/g" \
 ${MYCAT_HOME}/conf/schema.xml
for i in $(seq $[${#SERVER[*]}-1] -1 0);do
    sed -i "/<writeHost /a <readHost host=\"hostS$[i+1]\" url=\"${SERVER[$i]}\" user=\"${SLAVE_USERNAMES[$i]}\" password=\"${SLAVE_PASSWORDS[$i]}\"/>"  ${MYCAT_HOME}/conf/schema.xml
done;
cp ${MYCAT_HOME}/conf/server.xml.bak ${MYCAT_HOME}/conf/server.xml
sed -i \
    -e "s/\${DB_NAME}/$DB_NAME/g" \
    -e "s/\${USERNAME}/$USERNAME/g" \
    -e "s/\${PASSWORD}/$PASSWORD/g" \
 ${MYCAT_HOME}/conf/server.xml

./${MYCAT_HOME}/bin/mycat console

