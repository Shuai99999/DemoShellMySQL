#!/bin/bash
#echo "$(cat /dev/stdin)">input
#source /home/mysql/dba/bi/check_your_script
db=$1
mail=$2
sql=$3
file=$4
request_source="Export_platform"
userinfo=`cat /home/mysql/dba/userinfo |grep ${db} |sed -n 1p`
ip=`echo $userinfo | awk '{print $1}'`
port=`echo $userinfo | awk '{print $2}'`
username=`echo $userinfo | awk '{print $3}'`
password=`echo $userinfo | awk '{print $4}'`
if [ ! -n "${sql}" ];then
        sql=`cat  /home/mysql/dba/bi/input`
	request_source="localhost_Mysql"
fi
schema=`echo $userinfo | awk '{print $6}'`
path=`echo $userinfo | awk '{print $7}'`
url=`echo $userinfo | awk '{print$8}'`
passw=`echo $userinfo | awk '{print$9}'`
date=`date "+%Y-%m-%d %X"`
echo "${date} 您的数据已导出，\n请登录rrswl导数ftp，打开文件资源管理器（任意文件夹），输入地址 ftp://10.135.30.96/ 输入用户名:${url}exp 密码:${passw}，查找文件:${file}.zip" >> rpt
#Database export section
mysql -h${ip} -P${port} -u${username} -p${password} --default-character-set=utf8 -e "${sql}" ${schema} > ${path}${file}.xls
echo "${path}${file}.xls"
file_name="${path}${file}.xls"
ora=`head -10  ${path}${file}.xls |egrep "error|at line" `
/bin/iconv -c --verbose -f UTF-8 -t GBK ${path}${file}.xls -o ${path}${file}_GBK.xls
rm -rf ${path}${file}.zip
zip -j ${file}.zip ${path}${file}_GBK.xls
#echo "--$ora--"
#if [ -e ${file_name} ] && [ -s ${file_name} ];then
#        if [ ! -n "$ora" ]; then
#                echo "success"
#        	/bin/iconv -c --verbose -f UTF-8 -t GBK ${path}${file}.xls -o ${path}${file}_GBK.xls
#		zip -j ${file}.zip ${path}${file}_GBK.xls
#		#send user
#		mail_title="数据已导出"
#		/bin/sh /data/ftp/log_to_mail.sh "您的数据已导出请查看附件" "${mail_title}" "${file}.zip" "${mail}"
#		echo "您的数据已导出，\n请登录rrswl导数ftp[ftp://10.135.30.96/${file}.xls] 用户名:${url}exp 密码:${passw}"
#		if [ $? -eq 1 ]; then
#                /bin/sh /data/ftp/log_to_mail.sh "您的数据已导出，\n请登录rrswl导数ftp[ftp://10.135.30.96/${file}.xls] 用户名:${url}exp 密码:${passw}" "${mail_title}" "" "${mail}"
#                fi
#		#rm -rf ${file}.zip
#		#send dba
#		mail_title="数据已导出"
#		/bin/sh /data/ftp/log_to_mail_err.sh "[${date}] Export data succeed.\n\ndatabases:${db}\nip:${ip}\nport:${port}\nschema:${schema}\ndatafile path:${path}${file}.xls\nsql:${sql}\nrequest_source:${request_source}" "${mail_title}" "" ""
#        else
#                #Throw exception
#		echo "failed"
#		#send dba
#        	mail_title="Expdb_execution_error_notice"        
#        	/bin/sh /data/ftp/log_to_mail_err.sh "[${date}] SQL execution failed.\n\ndatabases:${db}\nip:${ip}\nport:${port}\nschema:${schema}\ndatafile path:${path}${file}.xls\nsql:${sql}\nrequest_source:${request_source}" "${mail_title}" "" ""
#        fi
#else	
#	#Throw exception
#        echo "failed"
#	#send dba
#	mail_title="Expdb_data_error_notice"
#	/bin/sh /data/ftp/log_to_mail_err.sh "[${date}] failed to create export file or Empty file.\n\ndatabases:${db}\nip:${ip}\nport:${port}\nschema:${schema}\ndatafile path:${path}${file}.xls\nsql:${sql}\nrequest_source:${request_source}" "${mail_title}" "" ""
#fi
rm -rf ${path}${file}.xls
rm -rf ${path}${file}_GBK.xls
mv ${file}.zip ${path}
