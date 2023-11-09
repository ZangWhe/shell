# 有一个目录，如/data/att/，下有数百个子目录，比如/data/att/zhangsan /data/att/lisi
# 再下一层是以日期命名的目录，如/data/att/zhangsan/20230501
# 每天都会生成一个新的日期目录
# 由于/data/所在磁盘快满了
# 所以需要将老文件挪到另外一个新文件中
# 如mv /data/att/zhangsan/20230501 /datanew/att/zhangsan/20230501
# 挪完之后还需要做软连接
# 如：ln -s /datanew/att/zhangsan/20230501 /data/att/zhangsan/20230501

# 写一个脚本，要求/data/att下所有子目录都要按照这样操作
# 脚本每天01：00执行一次
# 注：要确保老文件成功挪到/datanew/att之后，再做软连接絮，需要有日志

### ----------------------------

#!/bin/bash

main()
{
	target_path='./data/att/'
	save_path='./datanew/att/'
	cd ${target_path}
	## 遍历第一层目录
	for dir in `ls`
	do
		echo $dir
		## 遍历第二层目录
		## find执照当前目录下，一年以前的子目录
		for dir2 in `find ${dir} -maxdepth 1 -type d -mtime +365`
		do
			echo $dir2
			## 将目标目录下的文件同步到/datanew/att/目录下
			## -R可以自动创建目录结构
			rsync -aR $dir2/ ${save_path}
			if [ $? -eq 0 ]
			then
				## 如果同步成功，删除./data/att/下的对应目录
				rm -rf $dir2
				echo "${target_path}${dir2} 移动成功"

				## 软链接
				ln -s ${save_path}${dir2} ${target_path}${dir2} && \
				echo "${target_path}$dir2成功创建软链接\n"
				
			else
				echo "${target_path}${dir2} 未移动成功"
			fi
		done
	done		
}

main &> ./tmp/move_old_data_`date +%F`.log

