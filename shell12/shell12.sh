# 编写一个带参数的脚本，实现下载文件的效果，参数有两个：
# 1）第一个参数为文件下载链接
# 2）第二个参数是文件保存目录
# 注：要判断保存目录是否为空

#-------------------------------------------------------------------------------

#!/bin/bash

# 无限循环，目的是为了创建目录
while :
do
	# 目录存在，跳出循环
	if [ -d $2 ]
	then
		break
	else
		# 目录不存在，村问是否创建
		read -p "目录不存在，是否要创建？(y/n):  " yn
		case $yn in
			y|Y)
				mkdir -p $2
				break
				;;
			n|N)
				# 不想创建，退出脚本
				exit 2
				;;
			*)
				# 输入不符合要求，再次询问
				echo "should input y|Y or n|N"
				continue
				;;
		esac
	fi
done

# 进入目标目录
cd $2
# 使用wget命令下载
wget $1

if [ $? -eq 0 ]
then
	echo "下载成功"
	exit 0
else
	echo "下载失败"
	exit 1
fi

