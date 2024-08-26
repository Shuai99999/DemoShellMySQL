#!/bin/bash
read -p "Enter expdb:" expdb
read -p "Enter expschema:" expschema
read -p "Enter expstable:" exptable

read -p "Enter impdb:" impdb
read -p "Enter impschema:" impschema

expuserinfo=`cat userinfo |grep "${expdb}" |sed -n 1p`
expip=`echo $expuserinfo | awk '{print $1}'`
expport=`echo $expuserinfo | awk '{print $2}'`
expusername=`echo $expuserinfo | awk '{print $3}'`
exppassword=`echo $expuserinfo | awk '{print $4}'`

impuserinfo=`cat userinfo |grep "${impdb}" |sed -n 1p`
impip=`echo $impuserinfo | awk '{print $1}'`
impport=`echo $impuserinfo | awk '{print $2}'`
impusername=`echo $impuserinfo | awk '{print $3}'`
imppassword=`echo $impuserinfo | awk '{print $4}'`

#read -p "Enter expip:" expip
#read -p "Enter expport:" expport
#read -p "Enter expuser:" expuser
#read -p "Enter exppassword:" exppassword
#read -p "Enter expdatabase:" expdatabase
#read -p "Enter impuser:" impuser
#read -p "Enter imppassword:" imppassword
#read -p "Enter impip:" impip
#read -p "Enter impport:" impport
#echo "mysqldump -h${expip} -P${expport} -u${expuser} -p${exppassword} --opt --default-character-set=utf8 --hex-blob --lock-all-tables -R --triggers --routines --events --databases ${expdatabase} | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' > ${expdatabase}.sql"
echo "导出语句"
if [ ! -n "${exptable}" ]; then

echo "mysqldump -h$expip -P$expport -u$expusername -p$exppassword --databases ${expschema} > ${expschema}.sql"

else
  
echo "mysqldump -h$expip -P$expport -u$expusername -p$exppassword --databases ${expschema} --tables ${exptable} > ${expschema}.sql"
  
fi

echo "导入语句"
echo "mysql -u${impusername} -p${imppassword} -h${impip} -P${impport} < ${expschema}.sql"
