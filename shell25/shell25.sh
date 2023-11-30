# 假设当前MySQL服务的root密码是123456，写脚本检测MySQL服务是否正常
# 比如，当前可以正常进入mysql执行show processlist，并检测当前MySQL服务是主还是从
# 如果是从，则判断他的主从服务器是否异常，如果是主，则什么都不需要做


#------------------------------------------

#!/bin/bash

# 启动mysql的命令
Mysql_c="mysql -uroot -p123456"

# 将登录MySQL
$Mysql_c -e "show processlist" >/tmp/mysql_pro.log 2>/tmp/mysql_log.err

# 将已知警告信息删除
sed -i '/Using a password on the command line interface can be insecure/d' /tmp/mysql_log.err

# 如果错误日志文件内容不为空，则认为MySQL服务不正常
if [ -s /tmp/mysql_log.err ]
then
	echo "MySQL服务不正常，错误信息为："
	cat /tmp/mysql_log.err
	rm -f /tmp/mysql_pro.log /tmp/mysql_log.err
	exit 1
else
	# 将show slave status的输出信息写入到临时文件
	$Mysql_c -e "show slave status\G" >/tmp/mysql_s.log 2>/dev/null

	# 如果临时文件不为空，则认为是从，否则就是主
	if [ -s /tmp/mysql_s.log ]
	then
		# 判断主从状态是否正常，主要就是看Slave_IO_Running和Slave_SQL_Running 是否都是Yes
		y1=`grep 'Slave_IO_Running:' /tmp/mysql_s.log|awk -F : '{print $2}' | sed 's/ //g'`
		y2=`grep 'Slave_SQL_Running:' /tmp/mysql_s.log|awk -F : '{print $2}' | sed 's/ //g'`

		# 只有两个都是Yes，主从状态才是正常的
		if [ $y1 == "Yes" ] && [ $y2 == "Yes" ]
		then
			echo "从状态正常"
		else
			echo "从状态异常"
		fi
	fi
fi
rm -f /tmp/mysql_pro.log /tmp/mysql_log.err /tmp/mysql_s.log
