#!/bin/bash
userinfo=`cat /home/mysql/dba/userinfo |grep "$1" |sed -n 1p`
ip=`echo $userinfo | awk '{print $1}'`
port=`echo $userinfo | awk '{print $2}'`
username=`echo $userinfo | awk '{print $3}'`
password=`echo $userinfo | awk '{print $4}'`
mysql -A -h$ip -P$port -u$username -p$password
