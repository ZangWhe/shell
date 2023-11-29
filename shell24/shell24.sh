# 写一个脚本判断你的Linux服务器是否开启web服务？（监听80端口）
# 如果开启了，请判断出跑的是什么服务，是Httpd还是nginx还是其他

#-----------------------------------------------------------------
#!/bin/bash

which_web()
{
	case $1 in
		httpd)
			echo "is Httpd"
			;;
		nginx)
			echo "is Nginx"
			;;
		*)
			echo "既不是Httpd也不是Nginx，而是另一个服务"
	esac
}


# 如果没有监听80端口，说明没有跑Web服务
port_n=`ss -lntp | grep ':80 ' | wc -l`
if [ ${port_n} -eq 0 ]
then
	echo "没有打开Web服务"
	exit
fi

# 将监听80端口的所有今年成去重后写入临时文件
ss -lntp | grep ':80 ' | awk -F '"' '{print $2}' | sort | uniq > /tmp/web.txt

# 计算临时文件有多少行
line=`wc -l /tmp/web.txt | awk '{print $1}'`

# 如果进程不止一种，那么需要做遍历
if [ $line -gt 1 ]
then
	for web in `cat /tmp/web.txt`
	do
		what_web $web
	done
else
	web=`cat /tmp/web.txt`
fi

# 直接for循环？

rm -f /tmp/web.txt
