startDate=2023-01-01
endDate=2024-04-01
startDateTime=`date -d "$startDate" +%s`
endDateTime=`date -d "$endDate" +%s`
 
diff=`expr $endDateTime - $startDateTime`
#计算天数（一天24*60*60=86400秒）
diffCount=$(expr $diff/86400/30)

cur_date=${startDate}
for i in `seq 1 $[diffCount]`
do
next_date=`date --date="${cur_date} +1 month" +%Y-%m-%d`
#echo ${cur_date} ${next_date}
./exp.sh polardb_cdkread_exp "" "
   SELECT
	t.SERVICE_CODE '86码',
	DATE_FORMAT( t.CREATED_DATE, '%Y-%m' ) '派单时间',
	count( 1 ) '单量',
	sum( total_fee ) 金额 
FROM
	wd_order_info_es t 
WHERE
	t.CREATED_DATE >= '2023-01-01' 
	AND t.CREATED_DATE < '2024-4-1' 
	AND t.ACTIVE_FLAG = '1' 
	AND t.ORDER_STATUS != '93' 
	AND t.ORDER_STATUS != '193' 
	AND t.ORDER_STATUS != '293' 
	AND t.ORDER_STATUS != '200' 
GROUP BY
	t.SERVICE_CODE;
" tttttt_${cur_date} > /dev/null
cur_date=${next_date}
done
