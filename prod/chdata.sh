#!/bin/bash
db=$1
sql=$2
# > /home/mysql/dba/prod/input
echo "" >> /home/mysql/dba/prod/input
echo "commit;" >> /home/mysql/dba/prod/input
if [ ! -n "${sql}" ];then
        sql=`cat /home/mysql/dba/prod/input`
fi
#Django_exp
userinfo=`cat /home/mysql/dba/userinfo |grep "$1" |sed -n 1p`
ip=`echo $userinfo | awk '{print $1}'`
port=`echo $userinfo | awk '{print $2}'`
username=`echo $userinfo | awk '{print $3}'`
password=`echo $userinfo | awk '{print $4}'`
#/bin/mysql -A -h${ip} -P${port} -u${username} -p${password} -e "${sql}"
/bin/mysql -A -h${ip} -P${port} -u${username} -p${password} -e "source /home/mysql/dba/prod/input" --force
