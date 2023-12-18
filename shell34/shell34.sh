# 在服务器上写一个监控脚本，要求：
# 1）每10s检测一次服务器上的httpd进程数，如果大于等于500的时候，就需要自动重启一下apache服务，并检测是否启动成功
# 2）如果没有正常启动则需要再启动一次，最大不成功数超过5次需要发邮件通知管理员，并且之后就不需要再检测
# 3）如果启动成功后，1分钟后再次检测httpd进程数，若正常则重复之前的操作，若还是大于等于500，则放弃重启并发邮件通知管理员，然后退出脚本

# ------------------------------------------------------------

#!/bin/bash

# 定义重启并检测apache服务的函数
check_service()
{
	count=0

	# 尝试重启apache3次
	for i in `seq 1 3`
	do
		/usr/local/apache2/bin/apachectl restart 2>/tmp/apache.err
		if [ $? -ne 0 ]
		then
			# 如果启动失败，计数器加1
			n=$[$n+1]
			sleep 5
		else
			break
		fi
	done

	# 如果三次都没成功，就需要发邮件
	if [ $n -eq 3 ]
	then
		echo "发邮件逻辑"
		exit 0
	fi
}

# 监控脚本，每10s检测一次
while true
do
	# 计算httpd进程数量
	p_n=`ps -C httpd --no-heading | wc -l`

	# 如果进程数大于等于500
	if [ ${p_n} -ge 500 ]
	then
		# 重启apache
		/usr/local/apache2/bin/apachectl restart
		if [ $? -ne 0 ]
		then
			check_service
		fi

		sleep 60
		p_n=`ps -C httpd --no-heading | wc -l`

		# 如果还是大于500，则发邮件
		if [ ${p_n} -ge 500]
		then
			echo "发邮件逻辑"
			exit 0
		fi
	fi
	sleep 10
done
