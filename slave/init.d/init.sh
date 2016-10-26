
# "${mysql[@]}" is defined in /docker-entrypoint.sh
"${mysql[@]}" -e "
STOP SLAVE FOR CHANNEL '';
reset slave;
CHANGE MASTER TO master_host='$MASTER_HOST',
master_port=$MASTER_PORT,
master_user='slave',
master_password='centling',
MASTER_AUTO_POSITION=1;
start slave;
"
