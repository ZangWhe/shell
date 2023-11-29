# 写一个监控脚本，监控iptables规则是否封掉了22端口，如果关掉了，重新打开
# 脚本用任务计划每分钟执行一次

#-------------------------------------------------

#!/bin/bash

$port=22

# 将iptables规则中，针对22端口进行DROP或者REJECT的规则ID记录的tmp/drop.txt中
/sbin/iptables -nvl --line-number | awk '$12 == "dpt:${port}" && $4 ~ /REJECT|DROP/ {print $1}' > /tmp/drop.txt

# 如果/tmp/drop.txt不为空，说明系统已经封了22端口
if [ -s /tmp/drop.txt ]
then
	# 使用tac命令从最后一行开始开始读取，因为id号会随着规则的数量的变化而变化，从后面开始删，前面的id不会变
	for id in `tac /tmp/drop.txt`
	do
		/sbin/iptables -D INPUT $id
	done
fi

# rm -f tmp/drop.txt
