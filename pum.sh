db_names=$1
usernames=$2

otp_pum=`oathtool --totp -b -d 6 W44IVOWDM4GZKPLE`
token_pum=`/bin/curl "https://xxx.com/shterm/api/authenticate" -H "Content-Type: application/json;charset=utf-8" -k -X POST -d '{"username": "xxx", "password": "xxx '${otp_pum}'"}' |awk -F : '{print $2}'|awk -F '"' '{print $2}'`

otp_69=`oathtool --totp -b -d 6 GYMOZITJLRZR7WB4`
token_69=`/bin/curl "https://19.126.0.69/shterm/api/authenticate" -H "Content-Type: application/json;charset=utf-8" -k -X POST -d '{"username": "xxx", "password": "xxx '${otp_69}'"}' |awk -F : '{print $2}'|awk -F '"' '{print $2}'`

for i in ${db_names}
do
i_ip=`echo ${i} | awk -F "-" '{print $2}'`
i_port=`echo ${i} | awk -F "-" '{print $4}'`

ip=${i_ip}
port=${i_port}
desc="xxx"
user="xxx"

# 使用pum录入资产
/bin/curl -H "st-auth-token:${token_pum}" -H "Content-Type: application/json;charset=utf-8" -X POST -k "https://xxx.com/shterm/api/dev" -d '{"name":"1169-'"${ip}"'-mysql-'"${port}"'","ip":"'"${ip}"'","type":"2","sysType":{"id":12},"department":{"id":1008}, "resGroups":[{"id":11}], "description":"'"${desc}"'","owner":{"id":103}, "extInfo":{"10":"生产","11":"'"${user}"'","80":"场景物流"},"services":{"services":{"MYSQL":{"port":'"${port}"',"database":"mysql","appclient":[4]}}}}'

# 老的pum代码备份
# /bin/curl -H "st-auth-token:${token_pum}" -H "Content-Type: application/json;charset=utf-8" -X POST -k "https://xxx.com/shterm/api/dev" -d '{"name":"1169-'"${ip}"'-mysql-'"${port}"'","ip":"'"${ip}"'","type":"2","sysType":{"id":12},"department":{"id":1008}, "resGroups":[{"id":11}], "description":"'"${desc}"'","owner":{"id":103}, "extInfo":{"10":"生产","11":"'"${user}"'","14":"开机","80":"场景物流"},"services":{"services":{"MYSQL":{"port":'"${port}"',"database":"mysql","appclient":[4,22]}}}}'

# 19.126.0.69只能录入账号不要录入资产，否则在申请拥护的时候选不到这个资产
#/bin/curl -H "st-auth-token:${a_token}" -H "Content-Type: application/json;charset=utf-8" -X POST -k "https://19.126.0.69/shterm/api/dev" -d '{"networkEnvironment":{"id":1}, "name":"1169-'"${ip}"'-mysql-'"${port}"'","ip":"'"${ip}"'","type":"2","sysType":{"id":12},"department":{"id":1048}, "owner":{"id":313}, "extInfo":{"10":"生产","11":"'"${user}"'","12":"场景物流","14":"开机"},"services":{"services":{"MYSQL":{"appclient":[4], "port":'"${port}"'}}}}'

#mysql_dbname=1169-${ip}-mysql-${port}
mysql_dbname=${i}

# 需要使用19.126.0.69获取resid了
resid=`/bin/curl -H "st-auth-token:${token_69}" -H "Content-Type: application/json;charset=utf-8" -X GET -k "https://19.126.0.69/shterm/api/dev?deletedIs=false&departmentCascade=true&page=0&search=${mysql_dbname}&size=10&sort=updateTime,desc&stateIs=0&type=2&typeIs=2" |awk -F ":" '{print $3}'|awk -F '"' '{print $1}' |awk -F "," '{print $1}'`


# 老的pum获取resid代码备份
# resid=`/bin/curl -H "st-auth-token:${token_pum}" -H "Content-Type: application/json;charset=utf-8" -X GET -k "https://xxx.com/shterm/api/dev?deletedIs=false&departmentCascade=true&page=0&search=${mysql_dbname}&size=10&sort=updateTime,desc&stateIs=0&type=2&typeIs=2" | awk -F "," '{print $1}' |awk -F":" '{print $3}'`

echo $resid

for username in ${usernames}
do
password=*WJXY4xXsKQq
chpwd=可改密
#选项如下：可改密,不可改密,不确定（可改密）,不确定（不可改密）,不确定,不可改密(密码遗失）

mysql_version=`/usr/local/mysql5722/mysql/bin/mysql -udba_find -pof09AH#-LLd -h${ip} -P${port} -N -e"select version();" |sed -n 1p`

if [[ ${mysql_version} == 5.6* ]] ; then
#5.6版本
/usr/local/mysql5722/mysql/bin/mysql -udba_find -pof09AH#-LLd -h${ip} -P${port} -e"create user \"${username}\" identified by \"${password}\";flush privileges;" --force
/usr/local/mysql5722/mysql/bin/mysql -udba_find -pof09AH#-LLd -h${ip} -P${port} -e"UPDATE mysql.user SET password=PASSWORD('*WJXY4xXsKQq'),password_expired='N' WHERE user="${username}";commit;grant select on *.* to \"${username}\";flush privileges;" --force
#mysql -udba_find -pof09AH#-LLd -h${ip} -P${port} -e"UPDATE mysql.user SET password=PASSWORD('*WJXY4xXsKQq'),password_expired='N' WHERE user="${username}";commit;grant select on sso.sys_menu to \"${username}\";flush privileges;" --force
else
#5.7版本
/usr/local/mysql5722/mysql/bin/mysql -udba_find -pof09AH#-LLd -h${ip} -P${port} -e "create user \"${username}\" identified by \"${password}\";alter user \"${username}\" identified by \"${password}\"; commit;grant select on *.* to \"${username}\";flush privileges;" --force
#mysql -udba_find -pof09AH#-LLd -h${ip} -P${port} -e "create user \"${username}\" identified by \"${password}\";alter user \"${username}\" identified by \"${password}\"; commit;grant select on sso.sys_menu to \"${username}\";flush privileges;" --force
fi


# 19.126.0.69登出命令
# /bin/curl "https://19.126.0.69/shterm/api/authenticate" -H "st-auth-token:${a_token}" -H "Content-Type: application/json;charset=utf-8" -k -X DELETE

# pum上已无法录入账号
# /bin/curl -H "st-auth-token:${a_token}" -H "Content-Type: application/json;charset=utf-8" -X PUT -k "https://xxx.com/shterm/api/dev/changeAccount/${resid}" -d '{"name": "'"${username}"'","password": "'"${password}"'", "role":"Normal", "extInfo":{"34":"'"${chpwd}"'"}}'

# 应该在19.126.0.69上录入账号
/bin/curl -H "st-auth-token:${token_69}" -H "Content-Type: application/json;charset=utf-8" -X PUT -k "https://19.126.0.69/shterm/api/dev/changeAccount/${resid}" -d '{"name": "'"${username}"'","password": "'"${password}"'", "extInfo":{"2": "可改密", "3": "可改密"}}'

done

done

