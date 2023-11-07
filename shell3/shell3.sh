# 检测本机所有磁盘分区读写是否正常

# 实现：遍历所有挂载点，新建一个测试文件，再删除该文件，如果可以正常新建删除，那么该挂载点正常

#!/bin/bash

for mount_p in `df |sed '1d' | grep -v 'tmpfs' | awk '{print $NF}'`
do
	touch ${mount_p}/testfile && rm -f ${mount_p}/testfile
	if [ $? -ne 0 ]
	then
		echo "${mount_p} 读写出错"
	else
		echo "${mount_p} 读写正常"
	fi

done
