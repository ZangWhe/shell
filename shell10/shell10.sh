
# 写一个监控脚本，监控某站点访问是否正常

# 提示：
## 1)可以将访问的站点以参数的形式提供，例如sh xxx.sh www.baidu.com
## 2)状态码为2xx或3xx表示正常
## 3)正常时echo正常，不正常时echo不正常

# -----------------------------------------------------
# !/bin/bash
# if ! which curl &>/dev/null
# then
#	echo "本机没有安装curl"
#	exit 1
# fi

# 获取状态码
code=`curl --connect-timeout 3 -I $1 2>/dev/null |grep 'HTTP'|awk '{print $2}'`

# 如果状态码时2xx或3xx，则条件成立
if echo $code | grep -qE '^2[0-9][0-9]|^3[0-9][0-9]'
then
	echo "$1访问正常"
else
	echo "$1访问异常"
fi
