# 检查系统是否被入侵过

# 知识点：用ps aux可以查看进程的PID，每个PID都会在/proc内产生
# 如果查看到的PID在/proc内是没有的，则进程被人修改过，代表系统可能被人入侵了

# ---------------------------------------------------------------------------------

#!/bin/bash

# 本shell脚本的pid赋值为m_p
m_p=$$

# 用ps命令将所有进程信息全部写入临时文件中
ps -elf | sed '1'd > /tmp/pid.txt

# 利用awk,将PID那一列截取出来（除本脚本PID），做遍历循环
for pid in `awk -v ppn=$m_p '$5 != ppn {print $4}' /tmp/pid.txt`
do
	# 如果不存在/proc/pid目录，则判定该进程有异常
	if ! [ -d /proc/$pid ]
	then
		echo "系统中五pid为$pid的目录，需要检查"
	fi
done

# 删除临时文件内
rm -f /tmp/pid.txt
