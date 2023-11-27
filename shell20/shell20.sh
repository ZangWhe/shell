# 写一个监控服务器CPU使用率的监控脚本

# 思路：使用top -bn1 命令，去除当前空闲CPU的百分比值（只取整数），然后用100减去这个数值

#-----------------------------------------------------------------------------

#!/bin/bash

while :
do
	# top -bn1: 进行一次次迭代，提供CPU使用情况信息
	# sed -n '3p': 使用sed从输出中提取第三行
	# awk -F 'ni,' '{print $2}'： 使用awk基于字符串'ni,'分割，并打印第二部分，其中包含空闲CPU百分比
	# cut -d. -f1 : 使用cut基于小数点(.)分割百分比，并去除第一个字段，即整数部分
	# sed 's/ //g': 将输出中的空格替换为空
	idle=`top -bn1 | sed -n '3p' | awk -F 'ni,' '{print $2}' | cut -d. -f1 | sed 's/ //g'`
	use=$[100-$idle]
	if [ $use -gt 90 ]
	then
		echo "CPU use percent too high!"
		# 或者是发邮件事件
	fi
	sleep 10
done

# 监控脚本既可以通过while+sleep实现，也可以通过crontab事件周期性执行任务
