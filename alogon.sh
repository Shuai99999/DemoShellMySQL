#!/bin/bash
if [[ ${1} == *:* ]] ; then
ip=`echo ${1} | awk -F ":" '{print $1}'`
port=`echo ${1} | awk -F ":" '{print $2}'`
mysql -A -h${ip} -P${port} -uxxx -p"xxx"
else
mysql -A -h$1 -P$2 -uxxx -p"xxx"
fi
