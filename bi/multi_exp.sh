IFS=";"
db=${1}
filename=${2}
i=1
sed -i 's/union all/;/g' /home/mysql/dba/bi/inputs
for sql in `cat /home/mysql/dba/bi/inputs`
do
echo $sql > /home/mysql/dba/bi/input
echo ";" >> /home/mysql/dba/bi/input
sed -i '/^[  ]*$/d' /home/mysql/dba/bi/input
# echo $i
/home/mysql/dba/bi/exp.sh ${db} "" "" ${filename}_${i} > /dev/null
# i=`expr ${i} + 1`
let i++
done
