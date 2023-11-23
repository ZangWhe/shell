# 写一个脚本可以接受选项[i,I],完成以下任务：
# 1）使用如下形式：xxx.sh [-i interface | -I ip]
# 2）当使用-i选项时，显示指定网卡的ip地址
#    当使用-I选项是，显示其指定ip所属的网卡

# 例如：sh xxx.sh -i ens160
#	sh xxx.sh -I 192.168.0.1
# 3）当使用除了[-i | -I]选项时，显示[-i interface | -I ip]此信息
# 4）当用户指定信息不符合时，显示错误(比如指定的eth0不存在)

#----------------------------------------------------------

#!/bin/bash
# 创建打印脚本使用帮助的函数
useage()
{
	echo "Please useage: $0 -i 网卡名字 or $0 -I ip地址"
}

# 当参数不等于2，要提供帮助信息
if [ $# -ne 2 ]
then
	useage
	exit
fi


# 在执行脚本前，先判断该文件是否存在，存在就删掉
[ -f ./tmp/eths.txt ] && rm -f ./tmp/eths.txt
# 创建新的临时文件
[ ! -f ./tmp/eths.txt ] && touch ./tmp/eths.txt

# 将本机所有网卡名字全部获取，暂计入临时文件
ip add | awk -F ":" '$1 ~ /^[1-9]/{print $2}' | sed 's/ //g' > ./tmp/eths.txt
# cat ./tmp/eths.txt

# 然后将本机所有网卡以及对应的IP记录到eth_ip.log文件里
# 在执行脚本前，先判断该文件是否存在，存在就删掉
[ -f ./tmp/eth_ip.log ] && rm -f ./tmp/eth_ip.log
# 创建新的临时文件
[ ! -f ./tmp/eth_ip.log ] && touch ./tmp/eth_ip.log


# 遍历网卡
for eth in `cat ./tmp/eths.txt`
do
	echo $eth
	# 获取网卡对应的IP
	ip=`ip add | grep -A5 ": $eth" | grep inet |grep -v inet6 | awk '{print $2}' | cut -d '/' -f 1`
	echo "$eth:$ip" >> ./tmp/eth_ip.log
done
# cat ./tmp/eth_ip.log

# 删除临时文件
del_tmp_file()
{
	[ -f ./tmp/eths.txt ] && rm -f ./tmp/eths.txt
	[ -f ./tmp/eth_ip.log ] && rm -f ./tmp/eth_ip.log
}

# 当提供的网卡名字错误时要报错
wrong_eth()
{
	if ! awk -F ':' '{print $1}' ./tmp/eth_ip.log | grep -qw "^$1$"
	then
		echo "请指定正确的网卡名字"
		del_tmp_file
		exit
	fi
}

# 当提供的IP地址错误时要报错
wrong_ip()
{
	if ! awk -F ':' '{print $2}' ./tmp/ech_ip.log | grep -qw "^$1$"
	then
		echo "请指定正确的IP名字"
		del_tmp_file
		exit
	fi
}

# 根据第一个参数来决定执行什么命令
case $1 in
	-i)
		wrong_eth $2
		grep -w $2 ./tmp/eth_ip.log | awk -F ':' '{print $2}'
		;;
	-I)
		wront_ip $2
		grep -w $2 ./tmp/eth_ip.log | awk -F ':' '{print $1}'
		;;
	*)
		useage
		del_tmp_file
		exit
		;;
esac

del_tmp_file



