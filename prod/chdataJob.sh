#!/bin/bash
db=$1
sql=$2
echo "" >>/home/mysql/dba/prod/inputJob
echo "commit;" >>/home/mysql/dba/prod/inputJob
if [ ! -n "${sql}" ]; then
        sql=$(cat /home/mysql/dba/prod/inputJob)
fi
#Django_exp
userinfo=$(cat /home/mysql/dba/userinfo | grep "$1" | sed -n 1p)
ip=$(echo $userinfo | awk '{print $1}')
port=$(echo $userinfo | awk '{print $2}')
username=$(echo $userinfo | awk '{print $3}')
password=$(echo $userinfo | awk '{print $4}')
#/bin/mysql -A -h${ip} -P${port} -u${username} -p${password} -e "${sql}"
nohup /bin/mysql -A -h${ip} -P${port} -u${username} -p${password} -e "source /home/mysql/dba/prod/inputJob" --force >/home/mysql/dba/prod/inputJob.log
date=$(date)
echo $date >>/home/mysql/dba/prod/inputJob.log
