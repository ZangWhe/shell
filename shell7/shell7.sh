# 有一台f服务器作为web应用，有一个目录(/data/web/attachment)
# 不定时会被用户上传新的文件，但是不知道什么时候会上传
# 所以，需要我们每5分钟做一次检测看是否有新文件生成

# 还需要将新文件的列表输出到一个按年/月/日/时/分，为名字的日志中

# 思路：
## 定时任务，每五分钟执行一次检测
## 使用find命令查找5分钟内是否有过更新的文件
## 如果有更新，那么这个命令会有输出
## 因此，可以将输出结果的行数作为比较对象，大于0表示有新文件

# --------------------------
#!/bin/bash

# 日志文件名
date=`date +%Y%m%d%H%M`

targetdir='./data/web/attachment/'

find ${targetdir} -type f -mmin -5 > ./tmp/newf.txt

if [ -s /tmp/newf.txt ]
then
	echo ${d}.log
	mv ./tmp/newf.txt ./tmp/${d}.log
fi

