# 功能：当时间为0点和12点时，需要将目录/data/log/下的文件全部清空
# 注意是清空文件，而不是删除文件
# 其他时间只需要统计每一个文件的大小，一个文件一行，输出到一个按日期和时间为名字的日志中
# 需考虑/data/log/目录下的二级、三级等子目录里的文件

#-------------------------------------------------------------------------
#!/bin/bash

dir=/tmp/log_stat
t=`date +%d%H`
t1=`date +%H`
logdir=./data/log

# 目录不存在就创建目录
[ -d $dir ] || mkdir $dir

# 如果日志文件存在就删除该文件
[ -f $dir/$t.log ] && rm -f $dir/$t.log

# 当小时为0或者12时
if [ $t1 == "00" -o $t1 == "12" ]
then
	# 遍历所有文件,递归子目录
	for f in `find $logdir/ -type f`
	do
		# 清空文件
		> $f
	done
else
	# 遍历是所有文件
	for f in `find $logdir/ -type f`
	do
		du -sh $f >> $dir/$t.log
	done
fi
