# 输入一个数字，然后运行对应的一个命令

# 显示命令如下：
# *cmd menu** 1-date 2-ls 3-who 3-pwd
# 当输入1时，会运行date，输入2时，会运行ls,...

# ---------------------------------------------

#!/bin/bash

# 显示提示语
echo "*cmd menu** 1-date 2-ls 3-who 4-pwd"

# 适用死循环，目的是当用户输入的字符非指定字符时，
# 不直接推出脚本，而是重新开始

while :
do
	# 使用read实现和用户交互，提示让用户输入一个数字
	read -p "please input a number 1-4:" n
	case ${n} in
		1)
			date
			break
			;;
		2)
			ls
			break
			;;
		3)
			who
			break
			;;
		4)
			pwd
			break
			;;
		*)
			# 当输入不是1-4的数字，提示报错
			echo "Unlegal input,try again!"
			;;
	esac
done


