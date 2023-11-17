# 写一个日志归档脚本，类似于系统的logrotate程序做日志归档
# 假如服务的输出日志是1.log，要求每天归档一个，1.log第二天变成1.log.1，第三天1.log.2，第四天1.log.3,一直到1.log.5

# ---------------------------------------------------------

#!/bin/bash

# 思路：
# 要考虑该脚本是不是初次执行，还是执行了很久
# 如果是初次执行，那么日志目录里只有1.log，而没有其他的
# 也可能既有1.log也有1.log.2等

# 最常规的一个做法是：
# 如果这些文件都存在，先删除掉最后面的那个1.log.5，再将1.log.4变为1.log.5，以此类推


# 假设日志路径为/data

log_path=./data
cd ${log_path}

# 如果存在最旧的日志文件1.log.5，先删除掉
if [ -f 1.log.5 ]
then
	rm -f 1.log.5
fi

# 使用for + seq 做从5到2的倒序循环遍历
for i in `seq 5 -1 2`
do
	# 如果日志存在，则后缀加1
	if [ -f 1.log.$[$i-1] ]
	then
		mv 1.log.$[$i-1] 1.log.$i
	fi
done

if [ -f 1.log ]
then
	mv 1.log 1.log.1
fi

touch 1.log


