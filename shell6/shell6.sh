# 写一个监控脚本，监控系统负载，如果系统负载超过10，需要记录系统状态信息

## 1）系统负载命令适用uptime命令，查看过去一分钟的平均负载
## 2）系统状态适用如下工具标记：top,vmstat,ss
## 3）要求每20s监控一次
## 4）系统状态信息保存到/opt/logs/下面，保留一个月，文件名带有`data +%s`后缀或前缀

#----------

#!/bin//bash
log_save_path='./opt/logs/'
[ -d ${log_save_path} ] || mkdir -p ${log_save_path}

while :
do
	# 获取系统1分钟的负载，并且只取小数点前面的数字
	load=`uptime | awk -F 'average:' '{print $2}' | cut -d',' -f1 | sed 's/ //g' | cut -d'.' -f1`
	if [ $load -gt -1 ]
	then
		top -bn1 | head -n 100 > ${log_save_path}'log.'`date +%s`
		vmstat 1 10 > ${log_save_path}'vmstat.'`date +%s`
		ss -an > ${log_save_path}'ss.'`date +%s`
	fi
	# 休眠20s
	sleep 20
	# 找到30天以前的日志文件删除掉
	find ${log_save_path} \( -name "top*" -o -name "vmstat*" -o -name "ss*" \) -mtime +30 | xargs rm -f
done
	
