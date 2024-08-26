**这是MySQL DBA的工作目录，常用的shell脚本都放在这**

userinfo，保存各数据库的账号密码，格式是IP 端口 账号 密码 数据库名（自己起的名），其他脚本例如登录、修改数据、导出数据，均依赖这个数据库信息文件

logon.sh，alogon.sh 用于快速登录数据库

del_row.sh，del_row_arch.sh，用于循环删除MySQL数据，自动的每1万条提交一次，避免删除大量数据的时候产生数据库性能问题

pum.sh，用于在堡垒机中录入数据库和账号的信息，与officeAutomation中的passDBPriv搭配使用


**bi目录**

exp.sh，正常单个语句导出数据

multi_exp.sh，当一个文件中有多个SQL(用分号隔开)，导出数据时自动产生多个文件并追加后缀_1，_2，_3……

byDayExp.sh，byMonthExp.sh，基于上述基本导出数据逻辑，分别是按日和按月导出数据，要求是输入起始日期和结束日期，会自动计算中间需要循环多少次，产生多少导出文件，也是按日或按月产生多个文件

tmp_cdk_data.sh，与CMDB项目的导入临时数据搭配，用于IT服务台运维人员处理临时数据用


**prod目录**

chdata.sh，与officeAutomation项目的chdata功能搭配，用于自动处理IT服务台运维人员提报的数据变更流程，在数据库中自动执行他们提交的SQL


**dba目录**

fordba.sh，有些分片数据库，可以一次多一个分片的多个数据库实例做监控和巡检
