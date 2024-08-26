#/bin/bash
#for ip in `cat grant_ip`
#  do
cat tmp_list |while read line
do
ip=`echo $line |awk '{print$1}'`
port=`echo $line |awk '{print$2}'`
#    userinfo=`cat /home/mysql/dba/userinfo |grep ${ip} |sed -n 1p`
#    ip=`echo $userinfo | awk '{print $1}'`
#    port=`echo $userinfo | awk '{print $2}'`
#    username=`echo $userinfo | awk '{print $3}'`
#    password=`echo $userinfo | awk '{print $4}'`
        #for database in `mysql -h${ip} -P${port} -u${username} -p${password} -e "show databases;"`
	#do
	#if [[ $database == rps_* ]];then
	mysql -h${ip} -P${port} -uxxx -pxxx -e "grant all on *.* to omsadmin@'%' identified by 'p3S#6Ua!tV(igaz';flush privileges;"
	if [[ $? -eq 0 ]];then
	echo "grant success on ${database} in ${ip}" >> tmp_list.log
	fi
	#fi
	#done
done
	
