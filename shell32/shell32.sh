# 监控远程的一台机器的存活状态，当发现宕机时发邮件给自己
# 核心命令：ping -c10 ip

#------------------------------------------------
#!/bin/bash

IP="127.0.0.1"
email=""

n=`ping -c5 $IP | grep 'packet' | awk -F '%' '{print $1}' | awk '{print $NF}'`
if [ -z "$n" ]
then
	echo "脚本有问题"
	exit 1
else
	n1=`echo $n | sed 's/[0-9]//g'`
	if [ -n "$n1" ]
	then
		echo "脚本有问题"
		exit 1
	fi
fi

if [ $n -ge 20 ]
then
	echo "机器$IP宕机，丢包率是${n}%"
	#python mail.py $email "机器$IP宕机" "丢包率是${n}%"
else
	echo "机器$IP正常，丢包率是${n}%"
fi

