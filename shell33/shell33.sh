# 备份数据库
# 首先在本地服务器上保存一份数据，然后再远程拷贝一根
# 本地保存一周的数据，远程保存一个月的数据

# 假设已知mysql 账号密码，备份的数据库为dz，本地备份目录为/bak/mysql
# 假设远程服务器ip为127.0.0.1，远程提供了一个rsync服务，备份的地址是127.0.0.1::backup


#--------------------------------

#!/bin/bash

# 当执行到某一步有问题，立刻退出脚本，后续就不再执行了
set -e

d1=`date +%w`
d2=`date +%d`
local_bakdir=/bak/mysql
remote_bakdir=127.0.0.1::backup

# 备份函数
bak()
{
	echo "mysql backup begin at `date`"
	echo "执行mysqldump,备份文件为$local_bakdir/dz.sql.$d1"
	mysqldump -uroot -p****** dz > $local_bakdir/dz.sql.$d1
	echo "远程拷贝到$remote_bakdir/dz.sql.$d2"
	rsync -az $local_bakdir/dz.sql.$d1 $remote_bakdir/dz.sql.$d2
	echo "mysql backup at `date`"
}

# 正确和错误函数
bak >> ${local_bakdir}/mysqlbak.log 2>>${local_bakdir}/mysq;bak.err

# 关闭set -e功能
set +e
