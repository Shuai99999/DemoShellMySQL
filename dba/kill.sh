#!/bin/bash
IFS=$'\n\n'
userinfo=`cat /home/mysql/dba/userinfo |grep "$1" |sed -n 1p`
ip=`echo $userinfo | awk '{print $1}'`
port=`echo $userinfo | awk '{print $2}'`
username=`echo $userinfo | awk '{print $3}'`
password=`echo $userinfo | awk '{print $4}'`
#for kill in `mysql -h$ip -P$port -u$username -p$password -N -e "select concat('kill ',id,';') from information_schema.processlist where command <>'Sleep';" `
for kill in `mysql -h$ip -P$port -u$username -p$password -N -e "select concat('kill ',id,';') from information_schema.processlist where command <>'Sleep' and info like 'INSERT INTO xcode_node_info%' and time>30;" `
#for kill in `mysql -h$ip -P$port -u$username -p$password -N -e "select concat('kill ',id,';') from information_schema.processlist where upper(info) like 'SELECT%';" `
do
#echo ${kill}
mysql -h$ip -P$port -u$username -p$password -e "${kill}"
#mysql -h$ip -P$port -u$username -p$password -e "stop slave; set global sql_slave_skip_counter=1; start slave;"
#mysql -h$ip -P$port -u$username -p$password -e "drop database percona;"
#mysql -h$ip -P$port -u$username -p$password -e "stop slave; SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1; start slave;"
done
