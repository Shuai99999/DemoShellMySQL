startDate=2024-01-01
endDate=2024-02-01
startDateTime=`date -d "$startDate" +%s`
endDateTime=`date -d "$endDate" +%s`
filename=ggggggg
 
diff=`expr $endDateTime - $startDateTime`
#计算天数（一天24*60*60=86400秒）
diffCount=$(expr $diff/86400)

cur_date=${startDate}
for i in `seq 1 $[diffCount]`
do
next_date=`date --date="${cur_date} +1 day " +%Y-%m-%d`
#echo ${cur_date} ${next_date}
./exp.sh polardb_cdkread_exp "" "
SELECT
	es.ORDER_CODE,
	es.CAR_PHONE,
	es.ORDER_DATE,
	detail.auth_prd_code,
	es.CREATED_DATE,
	es.add9 
FROM
	wd_order_info_es es
	LEFT JOIN wd_order_details detail ON es.ORDER_ID = detail.ORDER_ID 
WHERE
	es.ORDER_STATUS IN ( '80', '90' ) 
	AND es.add9 >= '${cur_date}' 
	AND es.add9 < '${next_date}';
" ${filename}_${cur_date} > /dev/null
cur_date=${next_date}
done
