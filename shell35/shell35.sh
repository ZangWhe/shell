# 根据web服务器上的访问日志，把一些请求量非常高的ip给拒绝掉
# 并且每隔半小时把不再发起请求过请求量很小的ip给解封
# 假设一分钟内请求量高于100次的IP视为不正常请求，日志路径为/data/logs/access.log

# ------------------------------------------------

#!/bin/bash

# 封IP的函数
block_ip()
{
	# 上一分钟
	t1=`date -d "-1 min" +Y:%H:%M`
	log=/data/logs/access_log

	# 将上一分钟的日志截取出来定向输入到/tmp/tmp_last_min.log
	egrep "$t1:[0-9]+" $log > /tmp/tmp_last_min.log

	# 把IP访问次数超过100次的计算出来，写入到临时文件
	awk '{print $1}' /tmp/tmp_last_min.log | sort -n | uniq -c | sort -n | awk '$1>100 {print $2}' > /tmp/bad_ip.list

	# 看临时文件的行数
	n=`wc -l /tmp/bad_ip.list | awk '{print $1}'`

	# 如果临时文件行数为0，说明前面没有过滤出ip
	if [ $n -ne 0 ]
	then
		for ip in `cat /tmp/bad_ip.list`
		do
			iptables -I INPUT -s $ip -j REJECT
		done
	fi

	# 删除临时文件
	rm -f /tmp/tmp_last_min/log /tmp/bad_ip.list
}

# 定义解封IP函数
unblock_ip()
{
	# 将包数小于5个的ip记入IP白名单临时文件中
	iptables -nvL INPUT | sed '1d' | awk '$1<5 {print $8}' > /tmp/good_ip.list

	# 计算白名单临时文件行数
	n=`wc -l /tmp/good_ip.list | awk '{print $1}'`
	# 如果文件不为空
	if [ $n -ne 0 ]
	then
		# 遍历所有IP，以此解封
		for ip in `cat /tmp/good_ip.list`
		do
			iptables -D INPUT -s $ip -j REJECT
		done
	fi

	# 将计数器清零，从0开始
	iptables -Z

	# 删除临时文件
	rm -f /tmp/good_ip.list

}

# 获取当前时间中的分钟
t=`date +%M`
# 如果分钟为0或者30，，也就是每隔半小时会执行封IP的函数
# 先解封，再封
if [ $t == "00" ] || [ $t == "30" ]
then
	unblock_ip
	block_ip
fi

