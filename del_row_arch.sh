#/bin/bash
#ip_list=$1
condition=$2
database=$3
skip_log_bin=$4
for ip in ${1}
  do
    userinfo=`cat /home/mysql/dba/userinfo |grep ${ip} |sed -n 1p`
    ip=`echo $userinfo | awk '{print $1}'`
    port=`echo $userinfo | awk '{print $2}'`
    username=`echo $userinfo | awk '{print $3}'`
    password=`echo $userinfo | awk '{print $4}'`
    if [[ ${database} == "all" ]] ; then
        for database in `mysql -h${ip} -P${port} -u${username} -p${password} -A -e "show databases;"`
            do
            #if [[ ${database} == cdk* || ${database} == default ]] ; then
            del_count=`mysql -h$ip -P$port -u$username -p$password -A -e "select count(*) from ${condition};" $database |sed -n 2p`
            loop_row=10000
            loop_count=$[${del_count} / ${loop_row} + 1]
            for((i=1;i<=$loop_count;i++))
                do
                rd=$(($i*$loop_row))
                if [[ ${skip_log_bin} == "skip" ]]; then
                    mysql -h${ip} -P${port} -u${username} -p${password} -A -e "set sql_log_bin=0; delete from ${condition} limit $loop_row;commit;" ${database}
                else
                    mysql -h${ip} -P${port} -u${username} -p${password} -A -e "delete from ${condition} limit $loop_row;commit;" ${database}
                fi
                op_time=`date +"%Y-%m-%d %H:%M:%S"`
                echo ${op_time} "${condition} ${ip} ${database} ${rd} /${del_count} rows deleted"
            done
            #fi
        done &
    else
        #echo "single"
        del_count=`mysql -h${ip} -P${port} -u${username} -p${password} -A -e "select count(*) from ${condition};" ${database} | sed -n 2p`
        loop_row=10000
        loop_count=$[${del_count} / ${loop_row} + 1]
        for((i=1;i<=$loop_count;i++))
            do
            rd=$(($i*$loop_row))
            if [[ ${skip_log_bin} == "skip" ]]; then
                mysql -h$ip -P$port -u$username -p$password -A -e "set session  sql_log_bin=0; delete from ${condition} limit ${loop_row};commit;" ${database}
                #echo "mysql -h$ip -P$port -u$username -p$password -e set sql_log_bin=0; delete from ${condition} limit ${loop_row};commit; ${database}"
            else
                mysql -h$ip -P$port -u$username -p$password -A -e "delete from ${condition} limit ${loop_row};commit;" ${database}
                #echo "mysql -h$ip -P$port -u$username -p$password -e delete from ${condition} limit ${loop_row};commit; ${database}"
            fi
            op_time=`date +"%Y-%m-%d %H:%M:%S"`
            echo ${op_time} "${condition} ${ip} ${database} ${rd} /${del_count} rows deleted"
        done
    fi
done
