sed -i "s/^/insert into TMP_DATA values('/g" /home/mysql/dba/bi/for_insert.sql
sed -i "s/$/');/g" /home/mysql/dba/bi/for_insert.sql

mysql -A -hpxc-qdr1ksfraub9id.public.polarx.rds.aliyuncs.com -P3306 -uszh -pQaz@wsx789 -e "use cdkdb;truncate table cdkdb.tmp_data; source /home/mysql/dba/bi/for_insert.sql;"

