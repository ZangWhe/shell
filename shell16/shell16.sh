# 写一个脚本产生随机三位(包括前导0)的数字，并且可以根据用户的输入参数来判断输出几组

#--------------------------------


#!/bin/bash

# 思路：产生随机的一位数字，然后产生三次，再组合再一起

# 产生一位随机数
get_a_num(){
	n=$[ $RANDOM%10 ]
	echo $n
}

# 组合三位数字
get_numbers(){
	for i in 0 1 2
	do
		a[$i]=`get_a_num`
	done
	# 删除多余空格
	echo ${a[@]}|sed 's/ //g'

}

if [ $# -gt 1 ]
then
	echo "The number of your parameters can only be 1."
	echo "example: bash $0 5"
	exit
fi

# 如果没有提供参数，则直接产生一个3为数字
# 如果提供了参数，要判断参数是否是一个正整数
if [ $# -eq 1 ]
then
	m=`echo $1|sed 's/[0-9]//g'`
	if [ -n "$m" ]
	then
		echo "Usage bash $0 n,n should be a number,example: bash $0 5"
		exit
	else
		echo "The numbers are:"
		for i in `seq $1`
		do
			get_numbers
		done
	fi
else
	get_numbers
fi

