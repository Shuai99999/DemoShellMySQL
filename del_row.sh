#/bin/bash
> del.log
for ip in ${1}
  do
    userinfo=`cat /home/mysql/dba/userinfo |grep ${ip} |sed -n 1p`
    ip=`echo $userinfo | awk '{print $1}'`
    port=`echo $userinfo | awk '{print $2}'`
    username=`echo $userinfo | awk '{print $3}'`
    password=`echo $userinfo | awk '{print $4}'`
    if [ -z ${3} ] ; then
        for database in `mysql -h${ip} -P${port} -u${username} -p${password} -e "show databases;"`
            do
            #if [[ ${database} == cdk* || ${database} == default ]] ; then
            del_count=`mysql -h$ip -P$port -u$username -p$password -e "select count(*) from ${2}" $database |sed -n 2p`
            loop_row=100000
            loop_count=$[${del_count} / ${loop_row} + 1]
            for((i=1;i<=$loop_count;i++))
                do
                rd=$(($i*$loop_row))
                mysql -h${ip} -P${port} -u${username} -p${password} -e "delete from ${2} limit $loop_row;commit;" ${database} >> del.log
                op_time=`date +"%Y-%m-%d %H:%M:%S"`
                echo ${op_time} "${2} ${ip} ${database} ${rd} /${del_count} rows deleted"
            done
            #fi
        done &
    else
        echo "single"
        del_count=`mysql -h$ip -P$port -u$username -p$password -e "select count(*) from ${2}" ${3} | sed -n 2p`
        loop_row=100000
        loop_count=$[${del_count} / ${loop_row} + 1]
        for((i=1;i<=$loop_count;i++))
            do
            rd=$(($i*$loop_row))
            #mysql ${1} -e "set sql_log_bin=0;delete from ${2} limit ${loop_row};commit;" ${3} #注意是否需要关闭binlog同步
            mysql -h$ip -P$port -u$username -p$password -e "delete from ${2} limit ${loop_row};commit;" ${3} #注意是否需要关闭binlog同步
            op_time=`date +"%Y-%m-%d %H:%M:%S"`
            echo ${op_time} "${2} ${ip} ${3} ${rd} /${del_count} rows deleted"
        done
    fi
done
