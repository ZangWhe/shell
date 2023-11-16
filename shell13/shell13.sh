# 用shell脚本实现：多人抽签游戏，每人执行脚本实现一个随机数，具体要求如下

# 1）脚本执行后，输入人名，生成1-99之间的数字；
# 2）相同的名字重复执行，抽到的数字应该和之前的保持一致
# 3）前面已经出现过的数字，下次不能再出现
# 4）需要将名字和对应的数字记录到一个文件里
# 5）脚本一旦运行，除非按Ctrl+C停止，否则要一直运行

#---------------------------------------------
#!/bin/bash

# 假设记录名字和数字的文件为/tmp/name.log
# 文件格式为：name:number

# 创建生成随机数的函数
create_number()
{
	# 当遇到已经出现过的数字，需要自动再次生成随机数，用while循环实现
	while :
	do
		# $RANDOM生成一个随机数字，范围0-32767（0-2^15-1）
		# $RANDOM%99 + 1即可获得1-99之间的数字

		num=$[ $RANDOM%99+1 ]

		# 如果数字出现在了/tmp/name.log里，则n > 0，n就是数字出现的次数
		n=`awk -F ':' -v NUMBER=$num '$2 == NUMBER' ./tmp/name.log|wc -l`
		if [ $n -gt 0 ]
		then
			continue
		else
			echo $num
			break
		fi
	done
}


# while循环实现脚本不断运行
while :
do
	# 用户交互
	read -p "Please input your name: " name
	
	if [ ! -f ./tmp/name.log ]
	then
		number=$[ $RANDOM%99+1 ]
		echo "Your number is : $number"
		echo "$name:$number" > ./tmp/name.log
	else
		n=`awk -F ':' -v NAME=$name '$1 == NAME' ./tmp/name.log|wc -l`
		if [ $n -gt 0 ]
		then
			echo "Your name already exist."
			awk -F ':' -v NAME=$name '$1 == NAME' ./tmp/name.log
			continue
		else
			number=`create_number`
		fi
		echo "Your number is : $number"
		echo "$name:$number" >> ./tmp/name.log
	fi
done
