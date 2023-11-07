# 检查指定目录下的所有文件和目录，看是否满足以下条件：
## 1）所有文件权限为644
## 2）所有目录权限为755
## 3）文件和目录所有者为www，所属组为root

# 如果不满足，改成符合要求
## 权限要先判断，再修改，不能直接修改


#!/bin/bash

target_path='./data/wwwroot/app/'
for f in `find ${target_path}`
do
	echo $f
	# 查看文件权限
	f_p=`stat -c %a $f`
	# 查看文件所有者
	f_u=`stat -c %U $f`
	# 查看文件所属组
	f_g=`stat -c %G $f`

	# 判断是否为目录
	if [ -d $f ]
	then
		[ $f_p != '755' ] && chmod 755 $f
	else
		[ $f_p != '644' ] && chmod 644 $f
	fi
	
	[ $f_u != 'www' ] && chown www $f
	[ $f_g != 'root' ] && chown :root $f
done
