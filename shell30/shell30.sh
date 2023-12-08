# 交互式脚本，输入一个数字，输出一个正方形

#-----------------------------------------------------------------

#!/bin/bash

read -p "please input a number: " sum
a=`echo $sum | sed 's/[0-9]//g'`
if [ -n "$a" ]
then
	echo "请输入一个纯数字"
	exit 1
fi

for i in `seq $sum`
do
	for j in `seq $sum`
	do
		if [ $j -lt $sum ]
		then
			echo -n "* "
		else
			echo "*"
		fi
	done
done

