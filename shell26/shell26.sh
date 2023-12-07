# 写一个自动化重启脚本服务，当访问日志频繁出现502状态码的时候，重启php-fpm服务
# 提示
# 1）假定Nginx访问日志路径为/data/logs/www_access.log
# 2）重启php-fpm服务的命令为systemctl restart php-fpm
# 3）脚本每分钟执行一次，脚本截取上一分钟的日志，计算总行数以及出现502的行数，然后计算比例，比例超过某一个阈值就认为出现了问题应该重启

#------------------------------------------------------------------

#!/bin/bash

# 日志文件
log_file="./data/logs/www_access.log"

# 上一分钟
last_t=`date -d "-1 min" +%Y:%H:%M`

# 把最后一万行日志截取出来(加快过滤)，然后再从中过滤上一分钟的日志
tail -nn 10000 $lof_file | grep "/${last_t}:" > /tmp/last.log

# 计算上一分钟日志有多少行
last_1min_c=`wc -l /tmp/last.log|awk '{print $1}'`

# 再计算状态码为502的日志有多少行
code502_c=`grep -c '" 502 "' /tmp/last.log`

# 计算百分比
# 取小数点后两位，*100是取百分比，sed是去除小数点20.01 转换为2001与2000进行比较
p=`echo "scale=2; ${code502_c}*100/${last_1min_c}" | bc | sed 's/\n//'`

# 如果百分比超过20
if [ $p -gt 2000 ]
then
	echo "`date` 502日志大于20%,需要重启php-fpm服务" >> /tmp/restart_php-fpm.log
	systemctl restart php-fmp
fi

rm -f /tmp/last.log
