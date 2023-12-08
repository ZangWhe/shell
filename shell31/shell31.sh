# 交互式脚本，输入一个数字，打印一个相应大小的三角形

#-----------------------------------------------------------------
#!/bin/bash

while true
do
	read -p "please input the length: " n
	# 判断有没有输入字符
	if [ -z $n ]
	then
		echo "要输入一个数字"
		continue
	else
		n1=`echo $n | sed 's/[0-9]//g'`
		if [ -n "$n1" ]
		then
			echo "输入的不是纯数字，重新输入"
			continue
		else
			break
		fi
	fi
done

for i in `seq 1 $n`
do
	# 先打印空格，第一行是n-1，后面一次递减
	m=$[$n-$i]
	for j in `seq 1 $m`
	do
		echo -n " "
	done

	for k in `seq 1 $i`
	do
		echo -n "* "
	done

	echo
done
