# 编写一个巡检脚本，用于检测系统里的所有服务是否正常运行
# 假定，系统运行的服务有Nginx,MySQL,Redis,Tomcat
# 要求脚本有内容输出，可以明确告知服务是否正常运行

# 提示：
# 1）如果服务进程存在且端口监听说明服务正常
# 2）Nginx端口443
# 3）MySQL端口3306
# 4）Redis端口6397
# 5）Tomcat端口8825
# 6）进程是否存在使用pgrep 'xxx'
# 7）端口是否存在使用ss -lnp | grep 'xxxx'

#----------------------------------------------------------------------

#!/bin/bash

# 判断命令是否存在
check_tools()
{
	if ! which pgrep &>/dev/null
	then
		echo "本机没有pgrep命令"
		exit 1
	fi

	if ! which ss &>/dev/null
	then
		echo "本机没有ss命令"
		exit 1
	fi
}

# 使用pgrep来检测某服务进程是否存在
# 该函数返回值只有0或1
# 当返回值为0时说明进程存在，1表示进程不存在
check_ps()
{
	if pgrep "$1" &>/dev/null
	then
		return 0
	else
		return 1
	fi
}

# 使用ss -lnp来检测端口是否存在
check_port()
{
	port_n=`ss -lnp|grep ":$1 "|wc -l`
	if [ $port_n -ne 0 ]
	then
		return 0
	else
		return 1
	fi
}

# 检测服务是否正常
check_srv()
{
	if check_ps $1 && check_port $2
	then
		echo "$1服务正常"
	else
		echo "$1服务异常"
	fi
}


check_tools
check_srv nginx 443
check_srv mysql 3306
check_srv redis 6379
# tomcat检查有没有java进程
check_srv java 8825
check_srv python3 42045
