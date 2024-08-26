#!/bin/bash
#输入IP，脚本，输入参数，也可以不带，用这个做一些基本的DBA类查询
IFS=$'\n\n'
for userinfo in $(cat /home/mysql/dba/userinfo | egrep $1 | awk '{print $1,$2}'); do
  echo -e "$3" | ./dba.sh $userinfo $2
done
