# 写一个脚本，执行后，打印一行提示"Please input a number"
# 要求用户输入数字时，然后打印出该数字，然后再次要求用户输入
# 知道用户输入"exit"停止

# ---------------------------------------------

#!/bin/bash


while :
do
	read -p "Please input a number(Input "exit" to quit) : " n
	
	if [ $n == "exit" ]
	then
		exit
	fi
	# 该命令判断用户输入是否为一个数字
	# sed -r 's/[0-9]//g': sed命令用户查找并替换文本，使用正则表达式[0-9]匹配数字
		## 并使用空字符替换匹配的内容，-r表示穷扩展正则表达式
	
	# wc -c: wc命令用于统计文件的字符数，-c选项表示统计字符数
	num=`echo $n | sed -r 's/[0-9]//g' | wc -c`
	if [ $num -ne 1 ]
	then
		echo "输入不是一个数字，请重新输入"
	else
		echo "你的输入为: $n"
	fi
done

			
